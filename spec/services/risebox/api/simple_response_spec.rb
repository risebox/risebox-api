require 'spec_helper'

describe Risebox::Api::SimpleResponse do
  let(:device) { Risebox::Core::Device.new }
  subject      { Risebox::Api::SimpleResponse.new(device, {some: 'result'}) }

  describe '#response_headers' do
    it 'returns an empty hash' do
      subject.response_headers.should eq({})
    end
  end

  describe '#response_body' do
    it 'returns the result in a hash' do
      subject.response_body.should eq({result: device})
    end
  end
end