require 'spec_helper'
require 'playhouse/context'
require 'playhouse/play'

module Playhouse
  describe Play do
    before do
      class CalculateTax < Context
      end

      class ExampleAPI < Play
        context CalculateTax
      end
    end

    after do
      Playhouse.class_eval{remove_const :ExampleAPI}
      Playhouse.class_eval{remove_const :CalculateTax}
    end

    describe "when instantiated" do
      subject { ExampleAPI.new }
      let(:context) { mock(:context) }

      it "presents contexts as callable methods" do
        CalculateTax.actor :taxable_income
        CalculateTax.should_receive(:new).with(taxable_income: 123).and_return(context)
        context.should_receive(:call)

        #subject.respond_to?(:calculate_tax).should be_true
        subject.calculate_tax taxable_income: 123
      end
    end
  end
end