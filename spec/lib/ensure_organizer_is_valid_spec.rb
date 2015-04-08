require 'spec_helper'

describe SimpleService::EnsureOrganizerIsValid do

  context '#call' do

    class FooCommand < SimpleService::Command
      def call; true; end
    end

    class BadInheritanceCommand
      def call; true; end
    end

  end

end
