require 'spec_helper'

describe Risebox::Access::Device do

  subject { Risebox::Access::Device.new }

  describe '#device_for_credentials' do
    before do
      expect(Risebox::Core::Device).to receive(:for_credentials).with('my-key', 'my-token').and_return(@scoped_devices = double('devices'))
    end
    it 'returns the first device matching the given credentials' do
      @scoped_devices.stub(:first).and_return(device = double('device'))
      expect(subject.device_for_credentials('my-key', 'my-token')).to eq [true, device]
    end
    it 'returns a not_authorized error if no device matches the given credentials' do
      @scoped_devices.stub(:first).and_return(nil)
      expect(subject.device_for_credentials('my-key', 'my-token')).to eq [false, {error: :not_authorized, message: 'No device matches your credentials'}]
    end
  end

end