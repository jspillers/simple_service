module SimpleService
  class Result
    attr_accessor :value, :recorded_commands

    def initialize()
      @recorded_commands = []
    end

    def record_command(command_name, success)
      @recorded_commands << [command_name, success]
    end

    def commands
      @recorded_commands.map {|rc| rc[0] }
    end

    def successes
      @recorded_commands.map {|rc| rc[1] }
    end

    def success?
      successes.all?
    end

    def failure?
      !success?
    end
  end
end
