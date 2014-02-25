require 'spec_helper'
require 'playhouse/context'

module Playhouse
  describe Context do
    before do
      class ExampleContext < Context
        attr_accessor :performed

        def perform
          self.performed = true
        end
      end
    end

    after do
      Playhouse.class_eval{remove_const :ExampleContext}
    end

    describe 'constructing' do
      it 'does not allow an unspecified actor to be stored' do
        expect { ExampleContext.new(foobar: 'value') }.to raise_error(ArgumentError)
      end
    end

    describe '.actor' do
      let(:role) { double(:role) }

      it 'allows the actor to be passed into the constructor and stored' do
        ExampleContext.actor :foobar
        subject = ExampleContext.new(foobar: 'value')
        subject.foobar.should == 'value'
      end

      it 'extends the actor by the specified role' do
        ExampleContext.actor :foobar, role: role
        role.should_receive(:cast_actor).with('value').and_return('cast value')
        subject = ExampleContext.new(foobar: 'value')
        subject.call
        subject.foobar.should == 'cast value'
      end
    end
    
    describe '#inherit_actors_from' do
      before do
        class ParentContext < Context
          actor :current_user
          actor :other_actor
        end
        @parent = ParentContext.new current_user: 'user', other_actor: 'other'
        ExampleContext.actor :current_user
      end

      it 'loads actors that are unset' do
        subject = ExampleContext.new
        subject.inherit_actors_from @parent
        expect(subject.current_user).to eq 'user'
      end

      it 'does not load actors that are already set' do
        subject = ExampleContext.new current_user: 'user override'
        subject.inherit_actors_from @parent
        expect(subject.current_user).to eq 'user override'
      end

      it 'does not load actors for which it has no part' do
        subject = ExampleContext.new
        subject.inherit_actors_from @parent
        expect{subject.other_actor}.to raise_error
      end
    end

    describe '#call' do
      it 'calls perform' do
        subject = ExampleContext.new
        subject.call

        subject.performed.should be_true
      end

      it 'does not raise an error if an optional actor is not supplied' do
        ExampleContext.actor :foobar, optional: true
        subject = ExampleContext.new
        subject.call
      end

      it 'raises an error if a required actor is not supplied' do
        ExampleContext.actor :foobar
        subject = ExampleContext.new
        expect {
          subject.call
        }.to raise_error
      end
    end

    describe 'http_method' do
      it 'defaults to :get' do
        expect(ExampleContext.http_methods).to include(:get)
      end
      it 'can be set one at a time' do
        ExampleContext.http_method :post
        expect(ExampleContext.http_methods).to include(:post)
      end
      it 'can be set with an array' do
        ExampleContext.http_method [:get, :post]
        expect(ExampleContext.http_methods).to include(:get)
        expect(ExampleContext.http_methods).to include(:post)
      end
    end
  end
end