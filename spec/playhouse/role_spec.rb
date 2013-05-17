require 'spec_helper'
require 'playhouse/role'

module Playhouse
  describe Role do
    module ExampleRole
      include Role

      actor_dependency :dingbat

      def foobar
        'awesome!'
      end
    end

    class DingbatActor
      def dingbat
      end
    end

    subject { ExampleRole }
    let(:valid_actor) { DingbatActor.new }
    let(:invalid_actor) { Object.new }

    context "when casting as" do
      it "adds foobar method to actor" do
        player = subject.cast_actor(valid_actor)
        player.foobar.should == 'awesome!'
      end

      context "without a default role" do
        it "raises exception if an actor dependency is not met" do
          expect {
            subject.cast_actor(invalid_actor)
          }.to raise_error
        end
      end

      context "with a default role" do
        subject { ExampleRoleWithDefault }

        module DingbatProviderRole
          include Role
          def dingbat
          end
        end
        module ExampleRoleWithDefault
          include Role

          actor_dependency :dingbat, default_role: DingbatProviderRole

          def foobar
            'awesome!'
          end
        end

        it "auto casts actor with default role" do
          player = subject.cast_actor(invalid_actor)
          player.foobar
          player.dingbat
        end
      end
    end

    context "when casting an enumerable as" do
      it "extends each member of the enumerable" do
        players = subject.cast_all([valid_actor])
        players.first.foobar.should == 'awesome!'
      end
    end
  end
end