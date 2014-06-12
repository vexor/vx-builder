require 'spec_helper'

describe Vx::Builder::ScriptBuilder::Env do
  let(:app)    { ->(_) { 0 } }
  let(:script) { described_class.new app }
  let(:env)    { create :env }
  let(:run)    { script.call env }
  subject { run }

  it { should eq 0 }

  context "run it" do
    let(:command) { create :command_from_env, env: env }
    before { run }

    it "should be success" do
      system( %{bash -l -c "#{command}" } )
      expect($?.to_i).to eq 0
    end
  end

end
