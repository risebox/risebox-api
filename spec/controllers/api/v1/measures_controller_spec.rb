require 'spec_helper'

describe API::V1::MeasuresController do

  before do
    request.accept = "application/json"
    @device = double('device', id: 7)
    send_device_creds_for @device
    Risebox::Query::Measure.stub(:new).with(@device).and_return(mes_double = double)
    Risebox::Util::ServiceRescuer.stub(:new).with(mes_double).and_return(@measure_service = double('measure service'))
    controller.stub(:render)
  end

  describe '#index' do
    it 'queries the measure service for measures of given metric and returns the result as an API response' do
      @measure_service.stub(:list).with('PH metric').and_return([true, {some: 'PH measure'}])

      api_data_should_be([true, {some: 'PH measure'}]) do
        get :index, device_id: @device.id, metric_id: 'PH metric'
      end
    end
  end

  describe '#create' do
    it 'uses the measure service to create a new measure for given metric and returns the result as an API response' do
      @measure_service.stub(:create).with('PH metric', '7').and_return([true, {some: 'PH measure'}])
      api_data_should_be([true, {some: 'PH measure'}]) do
        post :create, device_id: @device.id, metric_id: 'PH metric', value: '7'
      end
    end
  end

end