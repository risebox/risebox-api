require 'spec_helper'

describe API::V1::APIController do

  controller(API::V1::APIController) do
    def index
      @device = 'my device'
      measure = 'my measure'
      api_response [true, measure]
    end
  end

  before do
    request.accept = "application/json"
  end

  context 'and result is NOT paginatable' do
    it 'creates a simple_response object with result, then uses its methods to format a proper json response and headers' do
      expected_response = { result: DummyMeasure.new(id: 3, name: 'PH', value: '7') }

      Risebox::Api::SimpleResponse.stub(:new).with('my measure', page: 2).and_return(response_double=double('response double'))
      response_double.stub(:response_headers).and_return({})
      response_double.stub(:response_body).and_return(expected_response)

      get :index, page: '2'

      expect(response.body).to eq({ result: {id: 3, name: 'PH', value: '7'}}.to_json)
    end
  end

  context 'and result is paginatable' do
    before do
      controller.stub(:supports_pagination?).with('my measure').and_return(true)
    end

    it 'creates a simple_response object with the request context and result, then uses its methods to format a proper json response and headers' do

      expected_response = { meta:     {current_page: 2, total_pages: 4},
                            result:   DummyMeasure.new(id: 12, name: 'PH', value: '7') }

      Risebox::Api::PaginatedResponse.stub(:new).with('my measure', page: 2).and_return(response_double=double('response double'))
      response_double.stub(:response_headers).and_return({'pagination-current' => 2, 'pagination-last' => 4})
      response_double.stub(:response_body).and_return(expected_response)

      get :index, page: '2'

      expect(response.headers['pagination-current']).to eq 2
      expect(response.headers['pagination-last']).to    eq 4
      expect(response.body).to                          eq({ meta:     {current_page: 2, total_pages: 4},
                                                             result:   {id: 12, name: 'PH', value: '7'}
                                                            }.to_json)
    end
  end

  describe '#supports_pagination' do
    it 'returns true if given object responds to :page and false otherwise' do
      expect(controller.send('supports_pagination?', OpenStruct.new)).to                    be_false
      expect(controller.send('supports_pagination?', OpenStruct.new(page: 'something'))).to be_true
    end
  end

end

class DummyMeasure
  include ActiveModel::Model
  include ActiveModel::SerializerSupport
  attr_accessor :id, :name, :value, :taken_at
end

class DummyMeasureSerializer < ActiveModel::Serializer
  root false
  attributes :id, :name, :value
end