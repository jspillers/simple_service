require 'spec_helper'

describe SimpleService::ValidatesExpectedKeys do

  let(:valid_keys) {{
    expected_keys: [:foo],
    provided_keys: [:foo],
    some_other_key: 'blah'
  }}

  context '#call' do

    let(:with_valid_keys) {
      SimpleService::ValidatesExpectedKeys.new(valid_keys)
    }

    let(:with_missing_keys) {
      _keys = valid_keys.merge(expected_keys: [:foo, :baz])
      SimpleService::ValidatesExpectedKeys.new(_keys)
    }

    let(:does_not_expect_any_keys) {
      _keys = valid_keys.merge(expected_keys: [])
      SimpleService::ValidatesExpectedKeys.new(_keys)
    }

    context 'when all arguments are valid' do

      it 'does not raise error' do
        expect {
          with_valid_keys.call
        }.to_not raise_error
      end

    end

    context 'when there are expected keys missing from provided keys' do

      it 'raises an error' do
        expect { with_missing_keys.call }.to raise_error(
          SimpleService::ExpectedKeyError,
          'keys required by the organizer but not found in the context: baz'
        )
      end

    end

    context 'no expected keys are given' do

      it 'does not raise error' do
        expect {
          does_not_expect_any_keys.call
        }.to_not raise_error
      end

    end

  end

end
