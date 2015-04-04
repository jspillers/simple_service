require 'rubygems'
require 'pry'
require 'simple_service'

class ConcatName < SimpleService::Command
  expects :first_name, :last_name
  returns :name

  def execute
    self.name = "#{first_name} #{last_name}"
  end
end

class CreateHelloString < SimpleService::Command
  expects :name
  returns :hello

  def execute
    self.hello = "#{name}, say hello world!"
  end
end

class SayHello < SimpleService::Organizer
  expects :first_name, :last_name
  returns :hello
  commands ConcatName, CreateHelloString
end

result = SayHello.new(first_name: 'Ruby', last_name: 'Gem').execute
puts result[:hello]
