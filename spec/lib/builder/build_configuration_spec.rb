require 'spec_helper'

describe Vx::Builder::BuildConfiguration do
  let(:default_content) { YAML.load fixture('travis.yml') }
  let(:content)         { default_content }
  let(:config)          { described_class.new content }
  subject { config }

  its(:to_hash)        { should_not be_empty }
  its(:rvm)            { should eq %w{ 2.0.0 } }
  its(:gemfile)        { should eq %w{ Gemfile } }
  its(:before_script)  { should eq ["echo before_script"] }
  its(:before_install) { should eq ["echo before_install"] }
  its(:script)         { should eq ["RAILS_ENV=test ls -1 && echo DONE!"] }
  its(:after_success)  { should eq ["echo after success"] }
  its(:image)          { should eq %w{ one two } }
  its(:language)       { should eq 'ruby' }
  its(:services)       { should eq %w{ rabbitmq } }
  its(:scala)          { should eq %w{ 2.10.3 } }
  its(:jdk)            { should eq %w{ openjdk7 } }

  context "to_hash" do
    subject { config.to_hash }

    it { should eq(
      {
       "after_success"  => ["echo after success"],
       "before_install" => ["echo before_install"],
       "install"        => ["echo install"],
       "before_script"  => ["echo before_script"],
       "cache" => {
         "directories"  => ["~/.cache"],
         "enabled"      => true
       },
       "env" => {
         "matrix"       => ["matrix"],
         "global"       => ["global"]
       },
       "gemfile"        => ["Gemfile"],
       "image"          => ["one", "two"],
       "jdk"            => ['openjdk7'],
       "language"       => ["ruby"],
       "rust"           => ['0.11.0'],
       "go"             => ['1.2.2'],
       "node_js"        => ['0.10'],
       "rvm"            => ["2.0.0"],
       "scala"          => ['2.10.3'],
       "script"         => ["RAILS_ENV=test ls -1 && echo DONE!"],
       "services"       => ['rabbitmq'],
       "vexor"          => {"timeout"=>10, "read_timeout"=>20},
       "deploy"         => [{"shell"=>"cap deploy production"}],
       "deploy_modules" => [],
       "bundler_args"   => ["--without development"],
       "before_deploy"  => ["echo before deploy"],
       "after_deploy"   => ["echo after deploy"],
       "matrix"         => {"exclude"=>[{"rvm"=>2.1}]},
       "parallel"       => [3],
       "parallel_job_number" => []
      }
    ) }
  end

  context "env" do
    subject { config.env }
    it { should be }
  end

  context "cache" do
    subject { config.cache }
    it { should be }
  end

  context "deploy" do
    subject { config.deploy }
    it { should be }
  end

  context "deploy_modules" do
    let(:content) { {
      "deploy_modules" => [
        { "shell" => "/bin/true" }
      ]
    } }
    it "should restore" do
      expect(config).to have(1).deploy_modules
      expect(config).to be_deploy_modules
    end
  end

  context "any?" do
    subject { config.any? }

    it "should be false when required keys" do
      %w{ rvm scala jdk language script }.each do |required_key|
        expect(described_class.new(required_key => "value")).to be_any
      end
    end

    it "should be false when no any required keys" do
      expect(described_class.new("before_script" => "value", "deploy" => "value")).to_not be_any
    end
  end

  context "empty?" do
    it "should be true if nil" do
      expect(described_class.new nil).to be_empty
    end

    it "should be true if empty hash" do
      expect(described_class.new({})).to be_empty
    end

    it "should be false if not empty hash" do
      expect(described_class.new({"script" => "value"})).to_not be_empty
    end

    it "should to_hash to be empty" do
      expect(described_class.new(nil).to_hash).to eq({})
    end

  end
end
