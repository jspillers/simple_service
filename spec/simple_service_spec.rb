require 'spec_helper'
require_relative 'support/basic_organizer'

RSpec.describe SimpleService do

  let(:params) do
    {
      foo: 'asdf',
      bar: 'qwer',
      command_one_success: true,
      command_two_success: true,
    }
  end

  it 'returns a result object' do
    result = BasicOrganizer.call(params)
    expect(result).to be_a SimpleService::Result
  end
end

#result = DoSomething.call(foo: 'asdf', bar: 'qwer')
#result.commands       #=> [commandOne, commandTwo, :command_three]
#result.success?    #=> true
#result.successful? #=> true
#result.value       #=> {final_result: 'combined modified asdf modified qwer'}
