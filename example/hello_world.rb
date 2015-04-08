require 'rubygems'
require 'simple_service'

class ConcatName < SimpleService::Command
  expects :first_name, :last_name
  returns :name

  def call
    self.name = "#{first_name} #{last_name}"
  end
end

class CreateHelloString < SimpleService::Command
  expects :name
  returns :hello

  def call
    self.hello = "#{name}, say hello world!"
  end
end

class SayHello < SimpleService::Organizer
  expects :first_name, :last_name
  returns :hello
  commands ConcatName, CreateHelloString
end

result = SayHello.new(first_name: 'Ruby', last_name: 'Gem').call
puts result[:hello]
