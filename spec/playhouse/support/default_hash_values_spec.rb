require 'spec_helper'
require 'playhouse/support/default_hash_values'

module Playhouse
  module Support
    describe DefaultHashValues do
      def subject_with(data)
        data.extend(DefaultHashValues)
      end

      describe "#value_or_default" do
        it "returns the value if it is not nil" do
          subject_with(key: 1).value_or_default(:key, 'fish').should == 1
          subject_with(key: false).value_or_default(:key, 'fish').should == false
        end

        it "returns the default if the value is nil" do
          subject_with(key: nil).value_or_default(:key, 'fish').should == 'fish'
        end
      end

      describe "#value_or_error" do
        it "returns the value if it is not nil" do
          subject_with(key: 1).value_or_error(:key, 'fish').should == 1
          subject_with(key: false).value_or_error(:key, 'fish').should == false
        end

        it "raises the error if the value is nil" do
          expect { subject_with(key: nil).value_or_error(:key, 'fish') }.to raise_error('fish')
        end
      end
    end
  end
end