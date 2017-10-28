require 'spec_helper'
require_relative 'support/basic_service'
require_relative 'support/looping_service'
require_relative 'support/empty_service'

RSpec.describe SimpleService do

  let(:params) do
    {
      foo: 'foo',
      bar: 'bar',
      command_one_success: true,
      command_two_success: true,
    }
  end

  let(:result) do
    BasicService.call(params)
  end

  before do
    SimpleService.configure do |config|
      config.verbose_tracking = false
    end
  end

  context '#call is successful' do
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

  context '#call that fails on step one' do
    let(:result) do
      BasicService.call(params.merge(command_one_success: false))
    end

    it 'returns a result object' do
      expect(result).to be_a SimpleService::Result
    end

    it 'returns failure' do
      expect(result.success?).to eq false
      expect(result.failure?).to eq true
    end

    it 'returns the correct result value' do
      expect(result.value).to eq(
        message: 'stuff went wrong with command one'
      )
    end
  end

  context '#call that fails on step two' do
    it 'returns the correct result value' do
      result = BasicService.call(params.merge(command_two_success: false))
      expect(result.value).to eq(
        message: 'stuff went wrong with command two'
      )
    end
  end

  context 'LoopingService' do
    it 'returns a result object' do
      expect(LoopingService.call(count: 0)).to be_a SimpleService::Result
    end

    it 'returns a result object' do
      expect(LoopingService.call(count: 0).value).to eq(count: 3)
    end
  end

  context 'improperly configured service class' do
    it 'raises error when no commands or call defined' do
      expect { EmptyService.call }.to raise_error(/No commands defined for EmptyService/)
    end
  end

  context 'record commands' do
    it 'records normal command execution' do
      expect(result.recorded_commands).to eq(
        [
          {
            class_name: 'BasicService',
            command_name: :upcase_foo,
            success: true,
          },
          {
            class_name: 'BasicService',
            command_name: :upcase_bar,
            success: true,
          },
          {
            class_name: 'ModifyFooBar',
            command_name: :call,
            success: true,
          },
          {
            class_name: 'CombineFooBar',
            command_name: :call,
            success: true,
          },
        ]
      )
    end

    it 'records verbose command execution' do
      SimpleService.configure do |config|
        config.verbose_tracking = true
      end

      expect(result.recorded_commands).to eq(
        [
          {
            class_name: 'BasicService',
            command_name: :upcase_foo,
            received_args: {
              foo: 'foo',
              bar: 'bar',
              command_one_success: true,
              command_two_success: true
            },
            success: {
              foo: 'FOO',
              bar: 'bar',
              command_one_success: true,
              command_two_success: true,
            },
          },
          {
            class_name: 'BasicService',
            command_name: :upcase_bar,
            received_args: {
              foo: 'FOO',
              bar: 'bar',
              command_one_success: true,
              command_two_success: true
            },
            success: {
              foo: 'FOO',
              bar: 'BAR',
              command_one_success: true,
              command_two_success: true,
            },
          },
          {
            class_name: 'ModifyFooBar',
            command_name: :call,
            received_args: {
              foo: 'FOO',
              bar: 'BAR',
              command_one_success: true,
              command_two_success: true,
            },
            success: {
              modified_foo: 'modified FOO',
              modified_bar: 'modified BAR',
              command_two_success: true,
            },
          },
          {
            class_name: 'CombineFooBar',
            command_name: :call,
            received_args: {
              modified_foo: 'modified FOO',
              modified_bar: 'modified BAR',
              command_two_success: true,
            },
            success: {
              combined_foo_bar: 'combined modified FOO modified BAR',
            },
          },
        ]
      )
    end
  end
end
