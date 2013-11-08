require 'spec_helper'
require 'playhouse/validation/actors_validator'

module Playhouse
  describe ActorsValidator do
    let(:part) { double(:part, name: :foobar, validators: []) }

    describe "#validate_actors" do
      it "does nothing part has no validators" do
        subject.validate_actors([part], {amount: 1})
      end

      context "with invalid fields" do
        before do
          invalid_validator = double(:validator)
          invalid_validator.should_receive(:validate_actor).with(123).and_raise(RequiredActorMissing.new(part_name: :foobar))
          part.stub(validators: [invalid_validator])
        end

        it "raises exception if the part has a validator which raises an exception" do
          expect {
            subject.validate_actors([part], {foobar: 123})
          }.to raise_error(ContextValidationError)
        end

        it "includes the details of all invalid fields in the exception" do
          begin
            subject.validate_actors([part], {foobar: 123})
          rescue ContextValidationError => error
            part_error = error.for_part(:foobar).first
            part_error.should be_a(RequiredActorMissing)
            part_error.part_name.should == :foobar
          end
        end
      end
    end
  end
end