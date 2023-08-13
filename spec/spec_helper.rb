$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib', 'simple_service')
$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH << File.join(File.dirname(__FILE__))

require 'simplecov-json'
SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter
SimpleCov.start

require 'pry'
require 'rspec'
require 'simple_service'
