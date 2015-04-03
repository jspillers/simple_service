module SimpleService
  class ArgumentValidator

    attr_accessor :context, :expects, :commands

    def initialize(opts)
      @context  = opts[:context]
      @expects  = opts[:expects]
      @commands = opts[:commands]
    end

    def execute
      validate_expected_arguments
      validate_commands_not_empty
      validate_commands_properly_inherit
      true
    end

    private

    def validate_expected_arguments
      arguments_not_included = []

      expects.each do |expected_arg|
        arguments_not_included << expected_arg unless context.has_key?(expected_arg)
      end

      if arguments_not_included.any?
        error_msg = 'keys required by the organizer but not found in the context: ' +
          arguments_not_included.join(', ')
        raise ExpectedKeyError, error_msg
      end
    end

    def validate_commands_not_empty
      if commands.nil? || commands.empty?
        error_msg = 'This Organizer class does not contain any command definitions'
        raise SimpleService::OrganizerCommandsNotDefinedError, error_msg
      end

    end

    def validate_commands_properly_inherit
      invalid_command_inherit = commands.select do |command|
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
