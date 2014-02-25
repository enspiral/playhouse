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

    context 'when instantiated' do
      subject { ExampleAPI.new }
      let(:context) { double(:context) }

      it 'presents contexts as callable methods' do
        CalculateTax.actor :taxable_income
        CalculateTax.should_receive(:new).with(taxable_income: 123).and_return(context)
        context.should_receive(:call)

        #subject.respond_to?(:calculate_tax).should be_true
        subject.calculate_tax taxable_income: 123
      end
      
      it 'presents callable methods with parent' do
        parent = double(:context)
        expect(subject).to receive(:execute_context_with_parent)
        
        subject.calculate_tax_with_parent parent, {}
      end

      it 'has a name' do
        expect(subject.name).to eq('example_api')
      end
    end

    describe 'resource' do
      before do
        module ExampleResource
          class Context1 < Context
          end
          class Context2 < Context
          end
        end
      end
      it 'loads all contexts inside a module' do
        ExampleAPI.stub(:context)
        expect(ExampleAPI).to receive(:context).with(ExampleResource::Context1)
        expect(ExampleAPI).to receive(:context).with(ExampleResource::Context2)
        ExampleAPI.contexts_for ExampleResource
      end

    end
  end
end