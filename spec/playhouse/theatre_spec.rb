require 'spec_helper'
require 'playhouse/theatre'

module Playhouse
  describe Theatre do
    def test_theatre
      Theatre.new({environment: 'test', load_db: false})
    end

    subject { test_theatre }

    after do
      Theatre.clear_current
    end

    describe ".current" do
      it "is set to this theatre if you start staging" do
        subject.start_staging
        Theatre.current.should == subject
      end

      it "is cleared if you stop staging" do
        subject.start_staging
        subject.stop_staging
        Theatre.current.should be_nil
      end

      it "raises an error if there is already something else staged" do
        test_theatre.start_staging
        expect { subject.start_staging }.to raise_error
      end
    end
  end
end