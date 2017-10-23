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

  let(:result) do
    BasicOrganizer.call(params)
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
      BasicOrganizer.call(params.merge(command_one_success: false))
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
      result = BasicOrganizer.call(params.merge(command_two_success: false))
      expect(result.value).to eq(
        message: 'stuff went wrong with command two'
      )
    end
  end

  context 'record commands' do
    it 'records normal command execution' do
      expect(result.recorded_commands).to eq(
        [
          {
            class_name: 'BasicOrganizer',
            command_name: :command_one,
            success: true,
          },
          {
            class_name: 'BasicOrganizer',
            command_name: :command_two,
            success: true,
          },
          {
            class_name: 'CommandOne',
            command_name: :modify_foo_bar,
            success: true,
          },
          {
            class_name: 'CommandTwo',
            command_name: :combine_foo_bar,
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
            class_name: 'BasicOrganizer',
            command_name: :command_one,
            received_args: {
              foo: 'asdf',
              bar: 'qwer',
              command_one_success: true,
              command_two_success: true
            },
            success: {
              foo: 'FOO',
              bar: 'qwer',
              command_one_success: true,
              command_two_success: true,
            },
          },
          {
            class_name: 'BasicOrganizer',
            command_name: :command_two,
            received_args: {
              foo: 'FOO',
              bar: 'qwer',
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
            class_name: 'CommandOne',
            command_name: :modify_foo_bar,
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
            class_name: 'CommandTwo',
            command_name: :combine_foo_bar,
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
