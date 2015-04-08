module SimpleService
  class Organizer

    include ServiceBase::InstanceMethods
    extend ServiceBase::ClassMethods

    attr_accessor :context

    def initialize(context={})
      @context = context

      setup_execute_chain
      define_getters_and_setters
    end

    def self.commands(*args)
      @commands = args
    end

    def commands
      self.class.instance_variable_get('@commands')
    end

    def execute
      with_validation do |_commands|
        _commands.each do |command|
          @context.merge!(command.new(context).execute)
        end
      end
    end

    private

    def with_validation
      add_validation_keys_to_context unless skip_validation

      _commands = skip_validation ? commands : [EnsureOrganizerIsValid] + commands

      yield(_commands)

      remove_validation_keys_from_context unless skip_validation
    end

    def add_validation_keys_to_context
      context.merge!(validation_hash)
    end

    def remove_validation_keys_from_context
      validation_hash.keys.each do |key|
        context.delete(key)
      end
    end

    def validation_hash
      @validation_hash ||= {
        provided_keys: context.keys,
        expected_keys: expects,
        provided_commands: commands
      }
    end
  end

end
