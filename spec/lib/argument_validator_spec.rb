require 'spec_helper'

describe SimpleService::ArgumentValidator do

  context 'execute' do

    class FooCommand < SimpleService::Command
      def execute; true; end
    end

    class BadInheritanceCommand
      def execute; true; end
    end

    class NoExecuteDefinedCommand < SimpleService::Command
    end

    let(:valid_args) {{
      context: { foo: 'bar'},
      expects: [:foo],
      returns: [:foo],
      commands: [FooCommand]
    }}

    context 'when all arguments are valid' do

      it 'does not raise error' do
        expect {
          SimpleService::ArgumentValidator.new(valid_args).execute
        }.to_not raise_error
      end

      it 'returns true' do
        expect(
          SimpleService::ArgumentValidator.new(valid_args).execute
        ).to eql true
      end

    end

    it 'raises error when context does not contain expected keys' do
      expect {
        args = valid_args.merge(expects: [:baz])
        SimpleService::ArgumentValidator.new(args).execute
      }.to raise_error(
        SimpleService::OrganizerExpectedKeyError,
        'keys required by the organizer but not found in the context: baz'
      )
    end

    it 'raises error when commands are not defined' do
      expect {
        args = valid_args.merge(commands: nil)
        SimpleService::ArgumentValidator.new(args).execute
      }.to raise_error(
        SimpleService::OrganizerCommandsNotDefinedError,
        'This Organizer class does not contain any command definitions'
      )
    end

    it 'raises error when commands do not inherit from SimpleService::Command' do
      expect {
        args = valid_args.merge(commands: [BadInheritanceCommand])
        SimpleService::ArgumentValidator.new(args).execute
      }.to raise_error(
        SimpleService::CommandParentClassInvalidError,
        'BadInheritanceCommand - must inherit from SimpleService::Command'
      )
    end

    it 'raises error when command does not define an execute method' do
      expect {
        args = valid_args.merge(commands: [NoExecuteDefinedCommand])
        SimpleService::ArgumentValidator.new(args).execute
      }.to raise_error(
        SimpleService::CommandExecuteNotDefinedError,
        'NoExecuteDefinedCommand - does not define an execute method'
      )
    end

  end

end
