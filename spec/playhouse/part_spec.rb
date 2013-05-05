require 'spec_helper'
require 'playhouse/part'

module Playhouse
  describe Part do
    subject { Part.new(:amount) }

    describe "#validators" do
      it "is empty for an optional part" do
        subject.optional = true
        subject.validators.should == []
      end

      it "includes a required actor validator if not optional" do
        subject.validators.first.should be_a(RequiredActorValidator)
      end
    end
  end
end