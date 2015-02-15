require 'spec_helper'

describe Risebox::Util::ServiceRescuer do

  class Service
    def working_method myparam
      "instance says #{myparam}"
    end
    def raises_not_found
      raise ActiveRecord::RecordNotFound.new("Couldn't find Risebox::Core::Device with id=0")
    end
    def raises_some_exception
      raise "some exception"
    end
  end

  subject       { Risebox::Util::ServiceRescuer.new(Service.new) }

  describe '#method_missing' do

    it '#forwards method calls to its instance and returns the result in no error raised' do
      expect(subject.working_method('hello decorator')).to eq 'instance says hello decorator'
    end

    it '#catches the record not found errors and returns a proper service splat' do
      expect(subject.raises_not_found).to eq [false, {error: :not_found, message: "Couldn't find Risebox::Core::Device with id=0"}]
    end

    it '#catches all errors and returns a proper service splat' do
      expect(subject.raises_some_exception).to eq [false, {error: :exception, message: "some exception"}]
    end

  end
end