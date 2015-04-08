require 'spec_helper'

describe SimpleService::ValidatesCommandsProperlyInherit do

  class ValidDummyCommand < SimpleService::Command
    def execute; true; end
  end

  class InvalidDummyCommand
    def execute; true; end
  end

  context '#execute' do
    it 'raises error when commands do not inherit from SimpleService::Command' do
      expect {
        SimpleService::ValidatesCommandsProperlyInherit.new(
          provided_commands: [InvalidDummyCommand]
        ).execute
      }.to raise_error(
        SimpleService::CommandParentClassInvalidError,
        'InvalidDummyCommand - must inherit from SimpleService::Command'
      )
    end

    it 'does not raises error when commands inherit from SimpleService::Command' do
      expect {
        SimpleService::ValidatesCommandsProperlyInherit.new(
          provided_commands: [ValidDummyCommand]
        ).execute
      }.to_not raise_error
    end
  end

end
