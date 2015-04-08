require 'spec_helper'

describe SimpleService::ValidatesCommandsNotEmpty do

  class DummyCommand < SimpleService::Command
    def execute; true; end
  end

  context '#execute' do

    it 'raises error when commands are not defined' do
      expect {
        SimpleService::ValidatesCommandsNotEmpty.new(provided_commands: nil).execute
      }.to raise_error(
        SimpleService::OrganizerCommandsNotDefinedError,
        'This Organizer class does not contain any command definitions'
      )
    end

    it 'does not raise error when commands are defined' do
      expect {
        SimpleService::ValidatesCommandsNotEmpty.new(provided_commands: [DummyCommand]).execute
      }.to_not raise_error
    end

  end

end
