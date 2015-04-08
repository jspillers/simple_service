# SimpleService

[![Code Climate](https://codeclimate.com/github/jspillers/simple_service/badges/gpa.svg)](https://codeclimate.com/github/jspillers/simple_service)
[![Test Coverage](https://codeclimate.com/github/jspillers/simple_service/badges/coverage.svg)](https://codeclimate.com/github/jspillers/simple_service)
[![Build Status](https://travis-ci.org/jspillers/simple_service.svg?branch=master)](https://travis-ci.org/jspillers/simple_service)

SimpleService gives you a way to organize service objects such that they adhere 
to the single responsibility principle. Instead of writing large service objects 
that perform multiple tasks, SimpleService allows you to breakdown tasks into a 
set of sequentially performed "Command" objects. Commands are very small classes 
that perform exactly one task. When properly designed, these command
objects can be reused in multiple organizers minimizing code duplication.

When an organizer is instantiated a hash of arguments is passed in. This hash 
is referred to as the context.  The context hash is carried along throughout 
the sequence of command executions and modified by each command. After a 
successful run, the keys specified are returned. If keys are not specified, the 
entire context hash is returned.

First, setup an Organizer class. An Organizer needs the following things defined:

  * expects: keys that are required to be passed into initialize when an 
    instance of organizer is created. If not defined the organizer will 
    accept arbitrary arguments.
  * returns: keys that will be returned when the organizer has executed all of 
    its commands
  * commands: classes that define all the steps that the organizer will execute. 
    The organizer will call #execute on each command in order and the context 
    hash is passed to each of these commands. Any keys within the context that 
    are modified will be merged back into the organizer and passed along to the 
    next command.

```ruby
class ProcessSomethingComplex < SimpleService::Organizer

  # optional - ensures the following keys are provided during instantiation
  # leave out to accept any arguments/keys
  expects :something, :another_thing

  # optional - specifies which keys get returned after #execute is called on
  # an organizer instance
  returns :modified_thing

  # what steps comprise this service
  # #execute will be called on an instance of each class in sequence
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
  def execute
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

## Usage

Using the service is straight forward - just instantiate it, passing in the 
intial context hash, and then call execute.

```ruby
starting_context = {
  something: '1', 
  :another_thing: AnotherThing.new
}
modified_context = ProcessSomethingComplex.new(starting_context).execute

modified_context[:modified_thing] # => 2
```

[hello world example](example/hello_world.rb)

If you are using this with a Rails app, placing top level services in 
app/services/ and all commands in app/services/commands/ is recommended. If
not using rails, a similar structure would also be recommended.

## Inspiration and Rationale

This gem is heavily inspired by two very nice gems: 
[mutations](https://github.com/cypriss/mutations) and
[light-service](https://github.com/adomokos/light-service). 

Mutations is a great gem, but lacks the concept of a top level organizer. 
LightService brings in the notion of the organizer object, but doesn't create 
instances of its action objects (what are referred to as commands here). Using 
instances rather than class level execute definitions allows the use of private 
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
