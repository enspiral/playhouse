require 'spec_helper'
require 'playhouse/production'

module Playhouse
  describe Production do
    let(:theatre)   { double(:theatre) }
    let(:interface) { double(:interface, build: instance) }
    let(:instance)  { double(:interface_instance) }

    describe "#run" do
      it "requires a theatre and an interface" do
        expect { subject.run(theatre: theatre) }.to raise_error(ArgumentError)
        expect { subject.run(interface: interface) }.to raise_error(ArgumentError)
      end

      it "opens the theatre" do
        theatre.should_receive :while_open
        subject.run(theatre: theatre, interface: interface)
      end

      it "runs the interface" do
        theatre.stub(:while_open).and_yield
        interface.should_receive(:build).with(subject).and_return(instance)
        instance.should_receive(:run)

        subject.run(theatre: theatre, interface: interface)
      end
    end
  end
end