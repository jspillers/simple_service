require 'spec_helper'

describe SimpleService::Command do

  class ValidCommand < SimpleService::Command

    expects :foo, :bar
    returns :bar, :baz

    def execute
      context.merge!(
        bar: 'modified',
        baz: 'blah'
      )
    end

  end

  class NoExecuteDefinedCommand < SimpleService::Command
  end

  describe '#execute' do

    context 'when #returns is not empty' do
      it 'returns the correct keys from the context' do
        expect(
          ValidCommand.new(foo: 'blah', bar: 'meh').execute
        ).to eql(bar: 'modified', baz: 'blah')
      end
    end

    context 'raises error' do

      it 'when command does not define an execute method' do
        expect {
          NoExecuteDefinedCommand.new.execute
        }.to raise_error(
          SimpleService::ExecuteNotDefinedError,
          'NoExecuteDefinedCommand - does not define an execute method'
        )
      end

    end

  end

  describe 'context' do

    it 'defines getters for each expected key' do
      expect(
        ValidCommand.new(foo: 'blah', bar: 'meh')
      ).to respond_to :foo
    end

    it 'defines setters for each expected key' do
      command = ValidCommand.new(foo: 'blah', bar: 'meh')
      command.foo = 'changed'
      command.bar = 'changed'

      expect(command.context).to eql({ foo: 'changed', bar: 'changed' })
    end

  end

end
