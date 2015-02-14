require 'spec_helper'

describe Risebox::Core::Device do

  subject { Risebox::Core::Device.new }

  it 'generates new access token, persists and supports mass assignment' do
    SecureRandom.stub(:hex).and_return('generated_token')
    # Risebox::Core::Device.any_instance.stub(:generate_token).and_return 'generated_token' #NNA Not working
    device = Risebox::Core::Device.create(name: 'Device Name', key: 'key', model: 'Hapy', version: '1', owner_id: 3)
    device.reload

    expect(device.name).to     eq 'Device Name'
    expect(device.key).to      eq 'key'
    expect(device.model).to    eq 'Hapy'
    expect(device.version).to  eq '1'
    expect(device.owner_id).to eq 3
    expect(device.token).to    eq 'generated_token'
  end

  describe 'relations' do
    it { should belong_to(:owner).class_name('Risebox::Core::User') }
    it { should have_many(:measures).dependent(:destroy) }
  end

  describe 'scopes' do

    it '#for_credentials returns devices where key and token matches the given ones' do
      expect(Risebox::Core::Device.for_credentials('my-key', 'my-token').where_values_hash).to eq({'key' => 'my-key', 'token' => 'my-token'})
    end

  end

  describe '#generate_token' do
    context 'given the generated token already exists' do
      it 'generates a new one' do
        Risebox::Core::Device.stub(:exists?).with(token: 'first token').and_return true, false
        Risebox::Core::Device.stub(:exists?).with(token: 'second token').and_return false

        SecureRandom.stub(:hex).and_return('first token', 'second token')

        expect(subject.generate_token).to eq 'second token'
      end
    end
  end

end