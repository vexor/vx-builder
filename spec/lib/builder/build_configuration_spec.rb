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
       "rvm"            => ["2.0.0"],
       "scala"          => ['2.10.3'],
       "script"         => ["RAILS_ENV=test ls -1 && echo DONE!"],
       "services"       => ['rabbitmq'],
       "artifacts"      => ["app/foo.txt", "app/*.txt", "app/", {"prefix"=>"$CI_JOB_ID/"}],
       "deploy"         => [{"command"=>"cap deploy production", "provider"=>"shell"}],
       "bundler_args"   => ["--without development"],
       "before_deploy"  => [],
      }
    ) }
  end

  context "env" do
    subject { config.env }

    context "when is array" do
      let(:content) { { 'env' => %w{ 1 2 3 } } }
      its(:matrix) { should eq %w{1 2 3} }
      its(:global) { should eq [] }
    end

    context "when is hash" do
      let(:content) { { 'env' => {
        'global' => "global",
        "matrix" => "matrix"
      } } }
      its(:matrix) { should eq %w{matrix} }
      its(:global) { should eq %w{global} }
    end

    context "when is empty" do
      let(:content) { {} }
      its(:matrix) { should eq [] }
      its(:global) { should eq [] }
    end
  end

  context "cache" do
    subject { config.cache }

    context "when directories present" do
      let(:content) { { "cache" => {
        "directories" => ["~/.cache"]
      } } }
      its(:directories) { should eq ["~/.cache"] }
      its(:enabled?)    { should be_true }
    end

    context "when directories is not exists" do
      let(:content) { {} }
      its(:directories) { should eq [] }
      its(:enabled?)    { should be_true }
    end

    context "when disabled" do
      let(:content) { { "cache" => false } }
      its(:directories) { should eq [] }
      its(:enabled?)    { should be_false }
    end
  end

  context "artifacts" do
    subject { config.artifacts }

    its(:prefix) { should eq "$CI_JOB_ID/" }
    its(:files)  { should eq ["app/foo.txt", "app/*.txt", "app/"] }

    context "when is empty" do
      let(:content) { {} }
      its(:files)      { should eq [] }
      its(:prefix)     { should be_nil }
      its(:attributes) { should eq [] }
    end
  end

  context "deploy" do
    subject { config.deploy }

    context "when is empty" do
      let(:content) { {} }
      its(:attributes) { should eq [] }

      it "build_configuration#deploy? should be false" do
        expect(config).to_not be_deploy
      end
    end

    context "when is array" do
      let(:content) { {
        "deploy" => [
          {
            "provider" => "some"
          }
        ]
      } }
      its(:attributes){ should eq [{"provider" => "some"}] }

      it "build_configuration#deploy? should be true" do
        expect(config).to be_deploy
      end
    end

    context "when is hash" do
      let(:content) { {
        "deploy" => {
            "provider" => "some"
          }
      } }
      its(:attributes){ should eq [{"provider" => "some"}] }

      it "build_configuration#deploy? should be true" do
        expect(config).to be_deploy
      end
    end

    context "with on:" do
      subject { config.deploy.providers.first.on }

      context "when is string" do
        let(:content) { {
          "deploy" => {
              "provider" => "some",
              "on"       => "production"
            }
        } }

        it "should be branch" do
          expect(subject).to eq(["production"])
        end
      end

      context "when is array" do
        let(:content) { {
          "deploy" => {
              "provider" => "some",
              "on"       => %w{ production master }
            }
        } }

        it { should eq %w{ production master } }
      end

    end
  end

end
