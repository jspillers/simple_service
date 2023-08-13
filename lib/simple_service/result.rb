module SimpleService
  class Result
    attr_accessor :value, :recorded_commands

    def initialize()
      @recorded_commands = Set.new
      @verbose_tracking = SimpleService.configuration.verbose_tracking
    end

    def success!(klass, command_name, result_value)
      record_command(klass, command_name, result_value, :success)
    end

    def failure!(klass, command_name, result_value)
      record_command(klass, command_name, result_value, :failure)
    end

    def append_result(other_result)
      self.value = other_result.value
      self.recorded_commands += other_result.recorded_commands
    end

    def commands
      self.recorded_commands.map {|rc| rc[:command_name] }
    end

    def successes
      self.recorded_commands.map {|rc| rc.has_key?(:success) }
    end

    def success?
      successes.all?
    end

    def failure?
      !success?
    end

    private

    attr_reader :verbose_tracking

    def record_command(klass, command_name, result_value, success_or_failure)
      command_attrs = {
        class_name: klass.to_s,
        command_name: command_name,
      }

      command_attrs[:received_args] = self.value if verbose_tracking
      command_attrs[success_or_failure] = verbose_tracking ? result_value : true

      self.recorded_commands << command_attrs
      self.value = result_value
    end
  end
end
