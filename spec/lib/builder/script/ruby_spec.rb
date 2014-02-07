require 'spec_helper'

describe Vx::Builder::Script::Ruby do
  let(:app)    { ->(env) { env } }
  let(:script) { described_class.new app }
  let(:env)    { create :env }
  let(:run)    { script.call env }
  subject { run }

  it { should eq env }

  context "run it" do
    let(:command) { create :command_from_env, env: env }
    subject { env }

    before { run }

    context "should be success" do
      its(:before_install)     { should_not be_empty }
      its(:announce)           { should_not be_empty }
      its(:install)            { should_not be_empty }
      its(:cached_directories) {  should eq %w{ ~/.rubygems } }
    end


  end

end
