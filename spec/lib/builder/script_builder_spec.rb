require 'spec_helper'

describe Vx::Builder::ScriptBuilder do
  let(:task)   { create :task }
  let(:source) { create :source }
  let(:script) { described_class.new task, source }
  subject { script }

  context "just created" do
    its(:source) { should eq source }
    its(:task)   { should eq task  }
  end

  context "#image" do
    subject { script.image }
    it { should eq 'one' }
  end

  context "vexor" do
    it "should avaialble timeout and read_timeout attributes" do
      expect(script.vexor.timeout).to eq 10
      expect(script.vexor.read_timeout).to eq 20

      simple_source = create :source, name: "simple.yml"
      simple_script = described_class.new task, simple_source
      expect(simple_script.vexor.timeout).to be_nil
      expect(simple_script.vexor.read_timeout).to be_nil
    end

  end

  context "#to_before_script" do
    subject { script.to_before_script }
    it { should be }
  end

  context "#to_after_script" do
    subject { script.to_after_script }
    it { should be }
  end

  context "#to_script" do
    subject { script.to_script }
    it { should be }
  end

end
