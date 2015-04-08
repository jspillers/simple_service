module SimpleService
  class ValidatesCommandsProperlyInherit < Command

    expects :provided_commands

    skip_validation true

    def execute
      # valid commands inherit from Command and do not inherit from service
      # reject all valid commands and anything left over is invalid
      invalid_commands = provided_commands.to_a.reject do |command|
        command.ancestors.include?(SimpleService::Command) ||
        command.ancestors.include?(SimpleService::Organizer)
      end

      if invalid_commands.any?
        error_msg = invalid_commands.join(', ') +
          ' - must inherit from SimpleService::Command'
        raise SimpleService::CommandParentClassInvalidError, error_msg
      end
    end

  end
end
