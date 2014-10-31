require 'spec_helper'

describe Vx::Builder::ScriptBuilder::Python do
  let(:app)    { ->(env) { env } }
  let(:script) { described_class.new app }
  let(:source) { create :source, name: "python.yml" }
  let(:env)    { create :env, source: source }
  let(:run)    { script.call env }
  subject { run }

  it { should eq env }

  context "run it" do
    subject { env }

    context "should be success" do
      before { run }
      its(:announce)  { should_not be_empty }
      its(:install)   { should_not be_empty }
      its(:script)    { should be_empty }
    end

    context "when script is empty" do
      before do
        env.source.script.clear
        run
      end
      its(:script) { should_not be_empty }
    end
  end

end
