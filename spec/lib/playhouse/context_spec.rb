require 'spec_helper'
require 'playhouse/context'

module Playhouse
  describe Context do
    before do
      class ExampleContext < Context; end
    end

    after do
      Playhouse.class_eval{remove_const :ExampleContext}
    end

    describe "constructing" do
      it "does not allow an unspecified actor to be stored" do
        expect { ExampleContext.new(foobar: 'value') }.to raise_error(ArgumentError)
      end
    end

    describe ".actor" do
      let(:role) { mock(:role) }

      it "allows the actor to be passed into the constructor and stored" do
        ExampleContext.actor :foobar
        context = ExampleContext.new(foobar: 'value')
        context.foobar.should == 'value'
      end

      it "extends the actor by the specified role" do
        ExampleContext.actor :foobar, role: role
        role.should_receive(:cast_actor).with('value').and_return("cast value")
        context = ExampleContext.new(foobar: 'value')
        context.foobar.should == 'cast value'
      end
    end
  end
end