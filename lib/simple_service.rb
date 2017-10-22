require 'simple_service/result'
require 'simple_service/exceptions'
require 'simple_service/version'

module SimpleService
  def self.included(klass)
    klass.extend ClassMethods
    klass.include InstanceMethods
  end

  module ClassMethods
    def call(**kwargs)
      self.new.call(kwargs)
    end

    def command(command_name)
      @commands ||= []
      @commands << command_name
    end

    def commands(*args)
      @commands ||= []
      @commands += args
    end
  end

  module InstanceMethods
    def result
      @result ||= Result.new
    end

    def commands
      self.class.instance_variable_get('@commands')
    end

    def call(**kwargs)
      result.value = kwargs

      commands.each do |command|
        @current_command = command

        command_output = if command.is_a?(Class)
          command.new.call(result.value)
        elsif command.is_a?(Symbol)
          method(command).call(result.value)
        end

        if command_output.is_a?(Result)
          result.value = command_output.value
          result.recorded_commands += command_output.recorded_commands
        end

        break if result.failure?
      end

      result
    end

    def success(result_value)
      record_result(result_value, true)
    end

    def failure(result_value)
      record_result(result_value, false)
    end

    def record_result(result_value, success)
      result.record_command(@current_command, success)
      result.value = result_value
    end
  end
end
