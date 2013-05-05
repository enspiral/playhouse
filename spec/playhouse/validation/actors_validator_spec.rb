require 'spec_helper'
require 'playhouse/validation/actors_validator'

module Playhouse
  describe ActorsValidator do
    let(:part) { mock(:part, name: :foobar, validators: []) }

    describe "#validate_actors" do
      it "does nothing part has no validators" do
        subject.validate_actors([part], {amount: 1})
      end

      it "raises exception if the part has a validator which raises an exception" do
        invalid_validator = mock(:validator)
        invalid_validator.should_receive(:validate_actor).with(123).and_raise(RequiredActorMissing.new({}))
        part.stub(validators: [invalid_validator])

        expect {
          subject.validate_actors([part], {foobar: 123})
        }.to raise_error(RequiredActorMissing)
      end
    end
  end
end