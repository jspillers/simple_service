# SimpleService

[![Gem Version](https://badge.fury.io/rb/simple_service.svg)](http://badge.fury.io/rb/simple_service)
[![Code Climate](https://codeclimate.com/github/jspillers/simple_service/badges/gpa.svg)](https://codeclimate.com/github/jspillers/simple_service)
[![Test Coverage](https://codeclimate.com/github/jspillers/simple_service/badges/coverage.svg)](https://codeclimate.com/github/jspillers/simple_service)
[![Build Status](https://travis-ci.org/jspillers/simple_service.svg?branch=master)](https://travis-ci.org/jspillers/simple_service)
<!--![](http://ruby-gem-downloads-badge.herokuapp.com/jspillers/simple_service)-->

SimpleService facilitates the creation of Ruby service objects into highly discreet, reusable,
and composable units of business logic. The core concept of SimpleService is the definition of 
"Command" objects/methods. Commands are very small classes or methods that perform exactly one task. 
When properly designed, these command objects can be composited together or even nested to create
complex flows.

## Installation

Add this line to your application's Gemfile:

    gem 'simple_service'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_service

# Setup and Basic Usage:

* load the gem
* include the SimpleService module into your service object class
* define one or more comamnds that it will perform, must accept either keyword arguments or a hash argument
* call `#success` or `#failure` with any values you wish to pass along to the next command (or wish to return if it is the last command)

```ruby
require 'rubygems'
require 'simple_service'

class DoStuff
  include SimpleService

  commands :do_something_important, :do_another_important_thing

  def do_something_important(name:)
    message = "hey #{name}"

    success(message: message)
  end

  def do_another_important_thing(message:)
    new_message = "#{message}, we are doing something important!"

    success(the_final_result: new_message)
  end
end

result = DoStuff.call(name: 'Alice')
result.success? #=> true
result.value #=> {:the_final_result=>"hey Alice, we are doing something important!"}
```

A failure:

```ruby
require 'rubygems'
require 'simple_service'

class DoFailingStuff
  include SimpleService

  commands :fail_at_something

  def fail_at_something(name:)
    message = "hey #{name}, things went wrong."

    failure(message: message)
  end
end

result = DoStuff.call(name: 'Bob')
result.success? #=> false
result.failure? #=> true
result.value #=> {:message=>"hey Bob, things went wrong."}
```

You can also use ClassNames as commands and to organize them into other files:

```
require 'rubygems'
require 'simple_service'

class CommandOne
  include SimpleService

  command :add_stuff

  def add_stuff(one:, two:)
    success(three: one + two)
  end
end

class CommandTwo
  include SimpleService

  command :add_more_stuff

  def add_more_stuff(three:)
    binding.pry
    success(seven: three + 4)
  end
end

class DoNestedStuff
  include SimpleService

  commands CommandOne, CommandTwo
end

result = DoNestedStuff.call(one: 1, two: 2)
result.success? #=> true
result.value #=> {:seven=>7}
```

If you are using this with a Rails app, placing top level services in 
app/services/ and all nested commands in app/services/commands/ is recommended. If
not using rails, a similar structure would also be recommended.

For further examination of usage, here are a few examples:

* [hello world example](example/hello_world.rb)
* [nested services example](example/nested_services.rb)
* [override #call on the organizer](example/override_organizer_call_method.rb)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
