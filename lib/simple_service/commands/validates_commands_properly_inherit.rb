module SimpleService
  class ValidatesCommandsProperlyInherit < Command

    expects :provided_commands

    skip_validation true

    def execute
      invalid_command_inherit = provided_commands.to_a.select do |command|
        # does the command class inherit from SimpleService::Command
        !(command.ancestors.include?(SimpleService::Command))
      end

      if invalid_command_inherit.any?
        error_msg = invalid_command_inherit.join(', ') +
          ' - must inherit from SimpleService::Command'
        raise SimpleService::CommandParentClassInvalidError, error_msg
      end
    end

  end
end
