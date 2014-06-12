require 'spec_helper'

describe Vx::Builder::ScriptBuilder::Java do
  let(:app)    { ->(env) { env } }
  let(:script) { described_class.new app }
  let(:source) { create :source, name: "scala.yml" }
  let(:env)    { create :env, source: source }
  let(:run)    { script.call env }
  subject { run }

  it { should eq env }

  context "run it" do
    subject { env }

    context "should be success" do
      before { run }
      its(:before_install) { should_not be_empty }
    end

  end

end
