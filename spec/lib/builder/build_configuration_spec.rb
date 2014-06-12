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
       "deploy"         => [{"shell"=>"cap deploy production"}],
       "bundler_args"   => ["--without development"],
       "before_deploy"  => ["echo before deploy"],
       "after_deploy"   => ["echo after deploy"]
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
end
