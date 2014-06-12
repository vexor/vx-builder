require 'spec_helper'

describe Vx::Builder::DeployBuilder do
  let(:params) { {
    "env"           => {
      'global' => "1",
      "matrix" => "2",
    },
    "image"         => "image",
    "before_script" => "before",
    "after_success" => "after",
    "script"        => "script",
    "deploy" => {
      "shell"         => "/bin/true",
      "branch"        => "master"
    }
  } }
  let(:matrix) { create(:matrix_builder, params) }
  let(:branch) { 'master' }
  let(:deploy) { described_class.new matrix, branch: branch }
  subject { deploy }


  context "just created" do
    it { should be }
    its(:base_build_configuration)    { should eq matrix.build_configuration }
    its(:matrix_build_configuration)  { should eq matrix.build.first }
    its(:matrix_build_configuration)  { should be }
    its(:branch)                      { should eq 'master' }
  end

  context "valid?" do
    it "should be true if deploy key exists and found deploy modules" do
      expect(deploy).to be_valid
      expect(deploy).to have(1).deploy_modules
      expect(deploy).to be_deploy
    end

    it "should be false if cannot found modules for deploy" do
      deploy = described_class.new matrix, branch: "production"
      expect(deploy).to_not be_valid
      expect(deploy).to have(0).deploy_modules
      expect(deploy).to be_deploy
    end

    it "should be false if deploy key does not exists" do
      matrix = create(:matrix_builder)
      deploy = described_class.new matrix, branch: "master"
      expect(deploy).to_not be_valid
      expect(deploy).to have(0).deploy_modules
      expect(deploy).to_not be_deploy
    end
  end

  context "build" do

    it "should create build_configuration with deploy_modules and without deploy" do
      expect(deploy.build).to be
      expect(deploy.build).to_not be_deploy
      expect(deploy.build).to be_deploy_modules
    end

    it "should be false if not valid" do
      deploy = described_class.new matrix, branch: "production"
      expect(deploy.build).to be_false
    end

    it "should remove attributes from BLACK_LIST" do
      config = deploy.build
      expect(config.image).to be_empty
      expect(config.before_script).to be_empty
      expect(config.script).to be_empty
      expect(config.after_success).to be_empty
    end

    it "should remove matrix env" do
      config = deploy.build
      expect(config.env.global).to eq(['1'])
      expect(config.env.matrix).to eq([])
    end
  end
end
