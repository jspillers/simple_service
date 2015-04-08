require 'spec_helper'

describe SimpleService::EnsureOrganizerIsValid do

  context '#execute' do

    class FooCommand < SimpleService::Command
      def execute; true; end
    end

    class BadInheritanceCommand
      def execute; true; end
    end

  end

end
