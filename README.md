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

# 2.0.0 update notes

This update is a major refactor from previous 1.x.x versions. After revisiting this codebase I decided that 
I needed to make SimpleService actually simple in both use and implementation. The gem has now been paired down
to about 150 lines of code.

* All functionality is added to your service class via module inclusion instead of inheritance
* The concept of an Organizer has been removed
* The DSL for defining interfaces has been removed in favor of simple keyword arguments
* `#success` or `#failure` must be called within each command or call method
* Services are always invoked via the class method `.call`. Previously you could use either `#call` or `.call`.

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

```ruby 
require 'rubygems'
require 'simple_service'

class CommandOne
  include SimpleService

  def call(one:, two:)
    if one == 1 && two == 2
      success(three: one + two)
    else
      failure(something: 'went wrong')
    end
  end
end

class CommandTwo
  include SimpleService

  def call(three:)
    if three == 3
      success(seven: three + 4)
    else
      failure(another_thing: 'went wrong')
    end
  end
end

class DoNestedStuff
  include SimpleService

  commands CommandOne, CommandTwo
end

result = DoNestedStuff.call(one: 1, two: 2)
result.success? #=> true
result.value #=> {:seven=>7}

result = DoNestedStuff.call(one: 2, two: 1)
result.success? #=> false
result.value #=> {something: 'went wrong'}
```

If you would like your service to process an enumerable you can override `#call`
on your service object. Invoking `#super` in your definition and passing along 
the appropriate arguments will allow your command chain to proceed as normal, but
called multiple times via a loop. The Result object returned from each call to `#super`
can be passed in as an argument to the next iteration or you can collect the result objects
yourself and then do any post processing required.

```ruby
require 'rubygems'
require 'simple_service'

class LoopingService
  include SimpleService

  commands :add_one

  def self.call(count:)
    count = kwargs

    3.times do
      count = super(count)
    end

    count
  end

  def add_one(count:)
    success(count: count + 1)
  end
end

result = LoopingService.call(count: 0) 
result.is_a?(SimpleService::Result) #=> true
result.value #=> {count: 3}
```

If you are using this with a Rails app, placing top level services in 
`app/services/` and all nested commands in `app/services/commands/` is 
recommended. Even if not using rails, a similar structure also works well.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
