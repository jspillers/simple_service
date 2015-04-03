$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib', 'simple_service')
$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH << File.join(File.dirname(__FILE__))

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'pry'
require 'rspec'
require 'simple_service'
