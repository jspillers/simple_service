module SimpleService
  class Organizer

    attr_accessor :context

    def initialize(context={})
      @context = context
      ArgumentValidator.new(
        context: context,
        expects: expects,
        returns: returns,
        commands: commands
      ).execute
    end

    def self.expects(*args)
      @expects = args
    end

    def self.returns(*args)
      @returns = args
    end

    def self.commands(*args)
      @commands = args
    end

    def commands
      self.class.instance_variable_get('@commands')
    end

    def expects
      self.class.instance_variable_get('@expects')
    end

    def returns
      self.class.instance_variable_get('@returns')
    end

    def execute
      commands.each do |command|
        @context.merge!(command.new(context).execute)
      end

      returns.inject({}) do |to_return, return_param|
        if context.has_key?(return_param)
          to_return[return_param] = context[return_param]
        else
          error_msg = "tried to return #{return_param}, but it did not exist in the context"
          raise OrganizerReturnKeyError, error_msg
        end

        to_return
      end
    end

  end
end
