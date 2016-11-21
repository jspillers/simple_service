module SimpleService
  class Organizer

    include ServiceBase::InstanceMethods
    extend ServiceBase::ClassMethods

    attr_accessor :context

    def initialize(_context = {})
      @context = validate_context(_context)

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
      # underscores used to disambiguate local vars from methods with the same name
      with_validation do |_commands|
        _commands.each do |command|

          # halt further command calls if success has been set to false
          # in a previously called command
          break if context[:success] == false

          # if command class defines "expects" then only feed the command
          # those keys, otherwise just give it the entire context
          _context = if command.get_expects.any?
            {}.tap do |c|
              command.get_expects.each {|key| c[key] = context[key] }
            end
          else
            context
          end

          # also merge any optional keys
          command.get_optional.each do |key|
            _context[key] = context[key]
          end

          # instantiate and call the command
          resulting_context = command.new(_context).call

          # update the master context with the results of the command
          @context.merge!(resulting_context)
        end
      end
    end

    # allow execution of the service from the class level for those
    # that prefer that style
    def self.call(context = {})
      self.new(context).call
    end

    private

    def validate_context(_context)
      unless _context.class == Hash
        raise InvalidArgumentError,
          "Hash required as argument, but was given a #{_context.class}"
      end

      _context
    end

    def with_validation
      # don't mess with the context if we are doing internal validation
      add_validation_keys_to_context unless skip_validation

      # ensure that the organizer and commands are setup correctly
      # by injecting an internal service organizer into the stack of
      # commands to be executed. Only include this if skip_validation is
      # not set. Since both user defined and internal services use this code
      # the skip_validation avoids an infinite loop
      _commands = skip_validation ? commands : [EnsureOrganizerIsValid] + commands

      yield(_commands)

      # cleanup context keys that are used by the validation so the final
      # return is clean even if the user does not define "returns" in their
      # organizer
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
