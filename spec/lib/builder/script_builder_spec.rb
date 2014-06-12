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
