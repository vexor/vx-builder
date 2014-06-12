require 'spec_helper'

describe Vx::Builder::BuildConfiguration::Deploy::Shell do
  let(:params) { {
    "shell"  => "echo true",
    "branch" => "master"
  } }
  subject { described_class.new params }

  context "#branch" do
    it "should be empty if key 'branch' is not exists" do
      expect(shell nil).to eq []
    end

    it "should be if string" do
      expect(shell "master").to eq ['master']
    end

    it "should be if array" do
      expect(shell [:master, :staging]).to eq %w{ master staging }
    end

    def shell(branch)
      described_class.new(params.merge("branch" => branch)).branch
    end
  end

  context "#to_commands" do

    it "should be empty if nil" do
      expect(shell nil).to eq []
    end

    it "should be if string" do
      expect(shell "command").to eq %w{ command }
    end

    it "should be if array" do
      expect(shell [:cmd1, :cmd2]).to eq %w{ cmd1 cmd2 }
    end

    def shell(command)
      described_class.new(params.merge("shell" => command)).to_commands
    end
  end

  context ".detect" do

    it "should be true if key shell exists" do
      expect(shell "shell" => "value").to be
    end

    it "should be false if key shell does not exists" do
      expect(shell "not_shell" => "value").to_not be
    end

    def shell(params)
      described_class.detect(params)
    end
  end
end
