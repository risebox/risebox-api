require 'spec_helper'

describe Risebox::Core::Measure do

  subject { Risebox::Core::Measure.new }

  it 'generates persists and supports mass assignment' do
    freeze_time
    measure = Risebox::Core::Measure.create(metric: 'PH', value: '8', taken_at: 1.minute.ago, device_id: 7)
    measure.reload

    expect(measure.metric).to     eq 'PH'
    expect(measure.value).to      eq '8'
    expect(measure.taken_at).to  eq 1.minute.ago
    expect(measure.device_id).to  eq 7
  end

  describe 'relations' do
    it { should belong_to(:device).class_name('Risebox::Core::Device') }
  end

  describe 'scopes' do
    it '#for_device returns measures for the given device' do
      expect(Risebox::Core::Measure.for_device('my-device').where_values_hash).to eq({'device_id' => 'my-device'})
    end

    it '#for_metric returns measures of the given metric' do
      expect(Risebox::Core::Measure.for_metric('PH').where_values_hash).to eq({'metric' => 'PH'})
    end

    it '#recent returns measures ordered by taken_at, the more recent the first' do
      query = Risebox::Core::Measure.recent.order_values.first

      expect(query.class).to     eq Arel::Nodes::Descending
      expect(query.expr.name).to eq :taken_at
    end
  end

end