require 'spec_helper'
require 'playhouse/talent_scout'
require 'playhouse/context'

module Playhouse
  describe TalentScout do
    context "for a context with a single actor" do
      subject { TalentScout.new }
      let(:actor) { double(:actor) }

      before do
        @context_class = Class.new(Context)
      end

      context "which is an entity" do
        let(:entity_repository) { double(:repository) }

        context "with a repository specified" do
          before do
            @context_class.actor :source_account, repository: entity_repository
          end

          it "finds the entity using the supplied id" do
            entity_repository.should_receive(:find).with('2').and_return(actor)
            context = subject.build_context(@context_class, :source_account_id => '2')
            context.source_account.should == actor
          end

          it "finds no entity if no id is supplied" do
            context = subject.build_context(@context_class, :some_other_id => '2')
            context.source_account.should == nil
          end

          it "uses the entity itself if it is supplied" do
            context = subject.build_context(@context_class, :source_account => actor)
            context.source_account.should == actor
          end
        end

        context "without a repository specified" do
          before do
            @context_class.actor :source_account
          end

          it "does not find the entity" do
            context = subject.build_context(@context_class, :source_account_id => '2')
            context.source_account.should == nil
          end

          it "uses the entity itself if it is supplied" do
            context = subject.build_context(@context_class, :source_account => actor)
            context.source_account.should == actor
          end
        end
      end

      context "which is a non persisted object" do
        context "with a composer specified" do
          let(:composer) { double(:composer) }

          before do
            @context_class.actor(:source_account, composer: composer)
          end

          it "allows the composer to build the object from it's attributes" do
            params = {source_account: 'Fred Savings'}
            composer.should_receive(:compose).with('Fred Savings').and_return(actor)

            context = subject.build_context(@context_class, params)

            context.source_account.should == actor
          end
        end
      end
    end
  end
end