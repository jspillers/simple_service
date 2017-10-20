require 'spec_helper'
require_relative 'support/basic_organizer'

RSpec.describe SimpleService do
  it 'does stuff' do
    expect(BasicOrganizer.call(foo: 'asdf', bar: 'qwer')).to be_a SimpleService::Result
  end
end
