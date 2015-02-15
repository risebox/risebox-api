require 'spec_helper'

describe Risebox::Query::Measure do

  let(:device) { d = Risebox::Core::Device.new ; d.id = 7 ; d }
  let(:metric) { 'PH' }
  subject      { Risebox::Query::Measure.new(device) }

  describe '#initialize' do
    it 'stores the passed device' do
      subject.device.should eq device
    end
  end

  describe '#list' do
    it 'returns all measures from the device for the given metric' do
      measures = Risebox::Core::Measure.should_receive_in_any_order({for_device: device}, {for_metric: 'PH'}, :recent)
      subject.list('PH').should eq [true, measures]
    end
  end

  describe '#build_new' do
    before do
      @now = freeze_time
    end
    it 'builds a new measure of the given metric and sets device to the service device' do
      measure = subject.build_new(metric, '8')

      expect(measure.is_a?(Risebox::Core::Measure)).to be_true
      expect(measure).to_not                           be_persisted
      expect(measure.metric).to                        eq metric
      expect(measure.value).to                         eq '8'
      expect(measure.taken_at).to                      eq @now
      expect(measure.device_id).to                     eq device.id
    end
  end

  describe '#create' do
    before do
      subject.stub(:build_new).with(metric, '8').and_return(@measure_double = double('measure'))
    end

    it 'creates a new measure with the given params, set the content_type, saves it and returns it with success result' do
      expect(@measure_double).to receive(:save).and_return true
      expect(subject.create(metric, '8')).to eq [true, @measure_double]
    end

    it 'creates a new measure with the given params, sets the owner tries saving it and returns it with failure result because save failed' do
      expect(@measure_double).to receive(:save).and_return false
      expect(subject.create(metric, '8')).to eq [false, @measure_double]
    end
  end

end
