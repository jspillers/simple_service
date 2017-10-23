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

# Setup

Basic Usage:

```ruby
require 'simple_service'

class DoStuff
  include SimpleService

  commands :do_something_important, :do_another_important_thing

  def do_something_important(name:)
    puts 'important stuff...'
    message = "hey #{name}, we are doing something important!"
    success(message: message)
  end

  def do_another_important_thing(message:)
    puts 'doing another important thing'
    new_message = "#{message} Why are we doing this?"
    success(the_final_result: new_message)
  end
end

DoStuff.call(name: 'Alice')

```

```ruby
class ProcessSomethingComplex
  commands DoSomethingImportant, DoAnotherStep
end
```
Next, define all command classes that make up the service. Each should inherit 
from SimpleService::Command and define similar things to the organizer:

```ruby
class DoSomethingImportant < SimpleService::Command
  
  # optional - creates getter/setter for each key specified, 
  # leave blank to accept arbitrary args
  expects :something

  # optional - creates getter/setter for each key specified, 
  # leave blank to return entire context hash
  returns :modified_something, :another_thing

  # required - this is where the work gets done, should only
  # do one thing (single responsibility principle)
  # getters and setters are available for each key specified
  # in expects and returns. If not using expects and returns
  # simply interact with the context hash directly
  def call
    # uses getters and setters to modify the context
    self.modified_something = self.something.to_i + 1

    # or act directly on the context hash
    context[:modified_something] = context[:something].to_i + 1

    # no need to return anything specific, either the keys 
    # specified in returns will be returned or the entire 
    # context if no returns are defined
  end

end

class DoSomethingImportant < SimpleService::Command
  ...
end
```

Within any command you can call ```#failure!``` and then return in order to
abort execution of subsequent commands within the organizer.

```ruby
class DemonstrateFailure < SimpleService::Command
  
  expects :something

  returns :good_stuff

  def call
    if good_stuff_happens
      self.good_stuff = 'yeah, success!'
    else
      failure!('something not so good happened; no more commands should be called')
    end
  end

end
```

## Usage

Using the service is straight forward - just instantiate it, passing in the 
intial context hash, and then call.

```ruby
starting_context = {
  something: '1', 
  :another_thing: AnotherThing.new
}
modified_context = ProcessSomethingComplex.new(starting_context).call

# alternatively, you can call directly from the service class
modified_context = ProcessSomethingComplex.call(starting_context)

modified_context[:modified_thing] # => 2
```

If you are using this with a Rails app, placing top level services in 
app/services/ and all commands in app/services/commands/ is recommended. If
not using rails, a similar structure would also be recommended.

For further examination of usage, here are a few examples:

* [hello world example](example/hello_world.rb)
* [nested services example](example/nested_services.rb)
* [override #call on the organizer](example/override_organizer_call_method.rb)

## Inspiration and Rationale

This gem is heavily inspired by two very nice gems: 
[mutations](https://github.com/cypriss/mutations) and
[light-service](https://github.com/adomokos/light-service). 

Mutations is a great gem, but lacks the concept of a top level organizer. 
LightService brings in the notion of the organizer object, but doesn't create 
instances of its action objects (what are referred to as commands here). Using 
instances rather than class level #call definitions allows the use of private 
methods within the command for more complex commands that still do a single thing.

The other goal of this gem is to do as little as possible above and beyond 
just using plain old Ruby objects (PORO's).  Things like error handling, logging, 
and context status will be left up to the individual to implement in a way that 
best suits their use case.

## Installation

Add this line to your application's Gemfile:

    gem 'simple_service'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_service

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
