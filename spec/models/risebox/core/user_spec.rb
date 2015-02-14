require 'spec_helper'

describe Risebox::Core::User do

  subject { Risebox::Core::User.new }

  it 'generates persists and supports mass assignment' do
    user = Risebox::Core::User.create(first_name: 'nicolas', last_name: 'nna', email: 'nna@risebox.co')
    user.reload

    expect(user.first_name).to    eq 'nicolas'
    expect(user.last_name).to     eq 'nna'
    expect(user.email).to         eq 'nna@risebox.co'
  end

  describe 'relations' do
    it { should have_many(:devices).class_name('Risebox::Core::Device') }
  end
end