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

  context '#call is successful:' do
    let(:result) do
      BasicOrganizer.call(params)
    end

    it 'returns a result object' do
      expect(result).to be_a SimpleService::Result
    end

    it 'returns success' do
      expect(result.success?).to eq true
    end

    it 'returns the correct result value' do
      expect(result.value).to eq(
        combined_foo_bar: 'combined modified FOO modified BAR'
      )
    end
  end
end

#result = DoSomething.call(foo: 'asdf', bar: 'qwer')
#result.commands       #=> [commandOne, commandTwo, :command_three]
#result.success?    #=> true
#result.successful? #=> true
#result.value       #=> {final_result: 'combined modified asdf modified qwer'}
