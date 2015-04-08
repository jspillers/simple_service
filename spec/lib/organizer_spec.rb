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

    describe '#call' do
      it 'returns the correct hash' do
        expect(
          TestOrganizer.new(foo: 'foo').call
        ).to eql(foo: 'foo', bar: 'bar', baz: 'baz')
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
        ).to eql(foo: 'foo', bar: 'bar', baz: 'baz', extra: 'extra')
      end

    end

  end

  describe 'service using getters and setters' do

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
      ).to eql({ baz: 'baz' })
    end

  end

end
