module SimpleService
  class Organizer

    include ServiceBase::InstanceMethods
    extend ServiceBase::ClassMethods

    attr_accessor :context

    def initialize(context = {})
      @context = context

      symbolize_context_keys
      setup_call_chain
      define_getters_and_setters
    end

    def self.commands(*args)
      @commands = args
    end

    def commands
      self.class.instance_variable_get('@commands')
    end

    def call
      with_validation do |_commands|
        _commands.each do |command|
          break if context[:success] == false
          new_context = command.new(context).call
          @context.merge!(new_context)
        end
      end
    end

    # allow execution of the service from the class level for those
    # that prefer that style
    def self.call(context = {})
      self.new(context).call
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
