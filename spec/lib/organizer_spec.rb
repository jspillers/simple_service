require 'spec_helper'

describe SimpleService::Organizer do

  context 'classes with expects and returns' do

    class TestCommandOne < SimpleService::Command
      expects :foo
      returns :foo, :bar
      def execute
        context.merge!(bar: 'bar')
      end
    end

    class TestCommandTwo < SimpleService::Command
      expects :foo, :bar
      returns :foo, :bar, :baz
      def execute
        context.merge!(baz: 'baz')
      end
    end

    class TestOrganizer < SimpleService::Organizer
      expects :foo
      returns :foo, :bar, :baz
      commands TestCommandOne, TestCommandTwo
    end

    describe '#execute' do
      it 'returns the correct hash' do
        expect(
          TestOrganizer.new(foo: 'foo').execute
        ).to eql(foo: 'foo', bar: 'bar', baz: 'baz')
      end

    end

  end

  context 'classes with only expects' do

    class TestCommandThree < SimpleService::Command
      expects :foo
      def execute
        context.merge!(bar: 'bar')
      end
    end

    class TestCommandFour < SimpleService::Command
      expects :foo, :bar
      def execute
        context.merge!(baz: 'baz')
      end
    end

    class TestOrganizerTwo < SimpleService::Organizer
      expects :foo
      commands TestCommandThree, TestCommandFour
    end

    describe '#execute' do
      it 'returns the entire context' do
        expect(
          TestOrganizerTwo.new(foo: 'foo', extra: 'extra').execute
        ).to eql(foo: 'foo', bar: 'bar', baz: 'baz', extra: 'extra')
      end

    end

  end

end
