module SimpleService
  class ValidatesCommandsNotEmpty < Command

    expects :provided_commands

    skip_validation true # prevent infinite loop

    def call
      if provided_commands.nil? || provided_commands.empty?
        error_msg = 'This Organizer class does not contain any command definitions'
        raise SimpleService::OrganizerCommandsNotDefinedError, error_msg
      end
    end

  end
end
