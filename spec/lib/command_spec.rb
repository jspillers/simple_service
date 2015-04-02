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

  context '#execute' do

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
          SimpleService::CommandExecuteNotDefinedError,
          'NoExecuteDefinedCommand - does not define an execute method'
        )
      end

    end

  end

end
