# SimpleService

SimpleService gives you a way to organize service objects such that they adhere 
to the single responsibility principle. Instead of writing large service objects 
that perform multiple tasks, SimpleService allows you to breakdown tasks into a 
set a sequentially performed Command objects. A context hash is carried along
throughout the sequence and modified by each command. After a successful run, the
entire context hash (or a specified subset) is returned.

First, setup an Organizer class. An Organizer needs the following things defined:
  * expects: keys that are required to be passed into initialize when an instance 
    of organizer is created. If not defined the organizer will accept arbitrary arguments.
  * returns: keys that will be returned when the organizer has executed all of its commands
  * commands: classes that define all the steps that the organizer will execute.

```ruby
class ProcessSomethingComplex < SimpleService::Organizer

  # ensures the following 
  expects :complex_thing, :another_thing

  returns :modified_thing

  commands DoSomethingImportant, DoAnotherStep

end
```

## Installation

Add this line to your application's Gemfile:

    gem 'simple_service'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_service

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
