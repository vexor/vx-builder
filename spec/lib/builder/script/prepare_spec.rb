require 'spec_helper'
require 'tmpdir'
require 'fileutils'

describe Vx::Builder::Script::Prepare do
  let(:app)    { ->(_) { 0 } }
  let(:script) { described_class.new app }
  let(:env)    { create :env }
  let(:run)    { script.call env }
  let(:path)   { Dir.tmpdir }
  subject { run }

  before { FileUtils.rm_rf(path) }
  after { FileUtils.rm_rf(path) }

  it { should eq 0 }

  context "run it" do
    let(:command) { create :command_from_env, env: env }
    before { run }

    context "success" do
      it "should return zero code" do
        Dir.chdir(path) do
          system( command )
        end
        expect($?.to_i).to eq 0
      end
    end
  end

end
