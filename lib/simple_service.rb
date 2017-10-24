require 'simple_service/result'
require 'simple_service/configuration'
require 'simple_service/version'

module SimpleService
  def self.included(klass)
    klass.extend ClassMethods
    klass.include InstanceMethods
    self.configure
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end

  module ClassMethods
    def call(**kwargs)
      service = self.new

      if service.method(:call).arity.zero?
        service.call
      else
        service.call(kwargs)
      end
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

    def call(kwargs)
      result.value = kwargs.is_a?(Result) ? kwargs.value : kwargs

      commands.each do |command|
        @current_command = command

        command_output = if command.is_a?(Class)
          command.new.call(result.value)
        elsif command.is_a?(Symbol)
          method(command).call(result.value)
        end

        if command_output.is_a?(Result)
          result.append_result(command_output)
        end

        break if result.failure?
      end

      result
    end

    def success(result_value)
      result.success!(self.class, @current_command, result_value)
    end

    def failure(result_value)
      result.failure!(self.class, @current_command, result_value)
    end
  end
end
