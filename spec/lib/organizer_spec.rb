require 'spec_helper'

describe SimpleService::Organizer do

  class TestCommandOne < SimpleService::Command
    def execute; {foo: 'blah'}; end
  end

  class TestCommandTwo < SimpleService::Command
    def execute; {bar: 'meh', baz: 'bleh'}; end
  end

  class TestOrganizer < SimpleService::Organizer
    expects :foo, :bar
    returns :foo, :baz
    commands TestCommandOne, TestCommandTwo
  end

  context '#execute' do
    it 'returns the correct hash' do
      expect(
        TestOrganizer.new(foo: 'blah', bar: 'meh').execute
      ).to eql(foo: 'blah', baz: 'bleh')
    end

    it 'calls execute on first command' do
      expect_any_instance_of(TestCommandOne).
        to receive(:execute).and_return(foo: 'blah')
      TestOrganizer.new(foo: 'blah', bar: 'meh').execute
    end

    it 'calls execute on first command' do
      expect_any_instance_of(TestCommandTwo).
        to receive(:execute).and_return(bar: 'meh', baz: 'bleh')
      TestOrganizer.new(foo: 'blah', bar: 'meh').execute
    end
  end

end
