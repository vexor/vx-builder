require 'spec_helper'

describe Vx::Builder::ScriptBuilder::Ruby do
  let(:app)    { ->(env) { env } }
  let(:script) { described_class.new app }
  let(:env)    { create :env }
  let(:run)    { script.call env }
  subject { run }

  it { should eq env }

  context "run it" do
    let(:command) { create :command_from_env, env: env }
    subject { env }

    context "should be success" do
      before { run }
      its(:before_install)     { should_not be_empty }
      its(:announce)           { should_not be_empty }
      its(:install)            { should_not be_empty }
      its(:cached_directories) {  should eq %w{ ~/.rubygems } }
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
