require 'spec_helper'
require 'tmpdir'
require 'fileutils'

describe Vx::Builder::ScriptBuilder::Prepare do
  let(:path) { Dir.tmpdir }

  before { FileUtils.rm_rf(path) }
  after { FileUtils.rm_rf(path) }

  def new_command(options = {})
    options[:task]   ||= create(:task)
    options[:env]    ||= create(:env, task: options[:task])
    options[:app]    ||= ->(_) { 0 }
    options[:script] ||= described_class.new options[:app]
    options[:script].call(options[:env])

    options[:cmd]    ||= create(:command_from_env, env: options[:env])
    options[:cmd]
  end

  it "should successfuly run command" do
    cmd = new_command
    Dir.chdir(path) do
      system( cmd )
    end
    expect($?.to_i).to eq 0
  end

  it "should be fail if reference if not in tree" do
    cmd = new_command(task: create(:task, sha: '8f53c077072674972e21c82a286acc07fada0000'))
    Dir.chdir(path) do
      system( cmd )
    end
    expect($?.to_i).to_not eq 0
  end

  it "should successfuly run for pull request" do
    cmd = new_command task: create(:task, pull_request_id: 1)
    Dir.chdir(path) do
      system( cmd )
    end
    expect($?.to_i).to eq 0
  end

end
