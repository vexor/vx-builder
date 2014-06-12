require 'spec_helper'

describe Vx::Builder::ScriptBuilder::Scala do
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
      its(:announce)           { should_not be_empty }
      its(:cached_directories) { should eq %w{ ~/.sbt ~/.ivy2 } }
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
