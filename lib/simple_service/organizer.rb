module SimpleService
  class Organizer

    include ServiceBase::InstanceMethods
    extend ServiceBase::ClassMethods

    attr_accessor :context

    def initialize(context={})
      @context = context

      ArgumentValidator.new(
        context: context,
        expects: expects,
        returns: returns,
        commands: commands
      ).execute

      setup_execute_chain
    end

    def self.commands(*args)
      @commands = args
    end

    def commands
      self.class.instance_variable_get('@commands')
    end

    def execute
      commands.each do |command|
        @context.merge!(command.new(context).execute)
      end
    end

  end

end
