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
      it "is set to this theatre if you open the theatre" do
        subject.open
        Theatre.current.should == subject
      end

      it "is cleared if you close" do
        subject.open
        subject.close
        Theatre.current.should be_nil
      end

      it "raises an error if there is already something else open" do
        test_theatre.open
        expect { subject.open }.to raise_error
      end
    end
  end
end