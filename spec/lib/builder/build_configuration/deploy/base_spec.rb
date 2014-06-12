require 'spec_helper'

describe Vx::Builder::BuildConfiguration::Deploy::Base do
  let(:params) { {
    "shell"  => "echo true",
    "branch" => "master"
  } }
  subject { described_class.new params }

  context "#branch" do
    it "should be empty if key 'branch' is not exists" do
      expect(get_branch nil).to eq []
    end

    it "should be if string" do
      expect(get_branch "master").to eq ['master']
    end

    it "should be if array" do
      expect(get_branch [:master, :staging]).to eq %w{ master staging }
    end

    def get_branch(branch)
      described_class.new(params.merge("branch" => branch)).branch
    end
  end

  context ".loaded" do
    subject { described_class.loaded }
    it { should have(1).items }
  end

end
