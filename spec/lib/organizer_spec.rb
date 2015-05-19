require 'spec_helper'

describe SimpleService::Organizer do

  context 'classes with expects and returns' do

    class TestCommandOne < SimpleService::Command
      expects :foo
      returns :foo, :bar
      def call
        context.merge!(bar: 'bar')
      end
    end

    class TestCommandTwo < SimpleService::Command
      expects :foo, :bar
      returns :foo, :bar, :baz
      def call
        context.merge!(baz: 'baz')
      end
    end

    class TestOrganizer < SimpleService::Organizer
      expects :foo
      returns :foo, :bar, :baz
      commands TestCommandOne, TestCommandTwo
    end

    describe '.call' do
      it 'returns the correct hash' do
        expect(
          TestOrganizer.call(foo: 'foo')
        ).to eql(foo: 'foo', bar: 'bar', baz: 'baz', success: true)
      end
    end

    describe '#call' do
      it 'returns the correct hash' do
        expect(
          TestOrganizer.new(foo: 'foo').call
        ).to eql(foo: 'foo', bar: 'bar', baz: 'baz', success: true)
      end

      it 'accepts string keys in context hash' do
        expect(
          TestOrganizer.new('foo' => 'foo').call
        ).to eql(foo: 'foo', bar: 'bar', baz: 'baz', success: true)
      end

    end

  end

  context 'classes with only expects' do

    class TestCommandThree < SimpleService::Command
      expects :foo
      def call
        context.merge!(bar: 'bar')
      end
    end

    class TestCommandFour < SimpleService::Command
      expects :foo, :bar
      def call
        context.merge!(baz: 'baz')
      end
    end

    class TestOrganizerTwo < SimpleService::Organizer
      expects :foo
      commands TestCommandThree, TestCommandFour
    end

    describe '#call' do
      it 'returns the entire context' do
        expect(
          TestOrganizerTwo.new(foo: 'foo', extra: 'extra').call
        ).to eql(foo: 'foo', bar: 'bar', baz: 'baz', extra: 'extra', success: true)
      end

    end

  end

  context 'service using getters and setters' do

    class GetterSetterCommand < SimpleService::Command
      expects :foo, :bar
      returns :baz
      def call
        self.baz = self.foo
      end
    end

    class GetterSetterOrganizer < SimpleService::Organizer
      expects :foo, :bar
      returns :baz
      commands GetterSetterCommand
    end

    it 'returns the correct hash' do
      expect(
        GetterSetterOrganizer.new(foo: 'baz', bar: 'bar').call
      ).to eql({ baz: 'baz', success: true })
    end

    describe '.get_expects' do

      it 'returns an array of expected keys' do
        expect(GetterSetterOrganizer.get_expects.sort).to eql [:bar, :foo]
      end

    end

  end

  context 'service with command that calls failure!' do

    class FailAndReturnErrorMessage < SimpleService::Command
      def call
        return failure!('something went wrong and we need to abort')
      end
    end

    class ShouldNotRun < SimpleService::Command
      def call
        raise 'should not have gotten here'
      end
    end

    class FailAndReturn < SimpleService::Organizer
      returns :something_not_set
      commands FailAndReturnErrorMessage, ShouldNotRun
    end

    it 'returns a message' do
      expect(FailAndReturn.call[:message]).to eql(
        'something went wrong and we need to abort')
    end

    it 'returns success as false' do
      expect(FailAndReturn.call[:success]).to eql(false)
    end

    it 'does not raise an exception' do
      expect { FailAndReturn.call }.to_not raise_error
    end

  end

end
