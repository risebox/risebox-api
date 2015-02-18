require 'spec_helper'

describe API::V1::DeviceSecuredController do
  controller(API::V1::DeviceSecuredController) do
    def index
      render text: 'authenticated'
    end
  end

  before do
    Risebox::Access::Device.stub(:new).and_return(cred_double = double)
    Risebox::Util::ServiceRescuer.stub(:new).with(cred_double).and_return(@cred_service = double('cred_service'))
    request.accept = "application/json"
  end

  context 'with valid device credentials passed in header' do
    before do
      request.headers['RISEBOX-SECRET'] = 'mysecret'
      @cred_service.stub(:device_for_credentials).with('LAB2', 'mysecret').and_return([true, @device = double('device')])
    end

    it 'assigns @device and proceed with requested action' do
      get :index, device_id: 'LAB2'
      expect(assigns(:device)).to eq @device
      expect(response.body).to    eq 'authenticated'
    end
  end

  context 'without valid device secret passed in header' do
    before do
      request.headers['RISEBOX-SECRET'] = 'wrongsecret'
      @cred_service.stub(:device_for_credentials).with('LAB2', 'wrongsecret').and_return([false, {error: :not_authorized, message: 'wrong device credentials'}])
    end
    it 'returns a 403 with the error message in json format' do
      get :index, device_id: 'LAB2'

      expect(response.status).to eq 403
      expect(response.body).to   eq({message: 'wrong device credentials'}.to_json)
    end
  end
end