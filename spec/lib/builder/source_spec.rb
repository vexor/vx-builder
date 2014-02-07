require 'spec_helper'

describe Vx::Builder::Source do
  let(:default_content) { YAML.load fixture('travis.yml') }
  let(:content)         { default_content }
  let(:config)          { described_class.from_attributes content }
  subject { config }

  its(:attributes)    { should be }
  its(:rvm)           { should eq %w{ 2.0.0 } }
  its(:gemfile)       { should eq %w{ Gemfile } }
  its(:before_script) { should eq ["echo before_script"] }
  its(:script)        { should eq ["RAILS_ENV=test ls -1 && echo DONE!"] }

  context "merge" do
    let(:new_attrs) { { rvm: "replaced" } }
    subject{ config.merge new_attrs }

    it "should build a new BuildConfiguration instance" do
      expect(subject).to be_an_instance_of(described_class)
    end

    it "should replace attributes" do
      expect(subject.attributes["rvm"]).to eq %w{ replaced }
    end
  end

  context "cached_directories" do
    subject { config.cached_directories }
    context "when cache is false" do
      let(:content) { default_content.merge("cache" => false) }
      it { should be_false }
    end
    context "when cache is nil" do
      let(:content) { default_content.delete("cache") && default_content }
      it { should eq [] }
    end

    context "when cache.directories is nil" do
      let(:content) { default_content["cache"].delete("directories") && default_content }
      it { should eq [] }
    end

    context "when exists" do
      it { should eq ["~/.cache"] }
    end
  end

  context "(serialization)" do

    context "build new instance" do
      let(:expected) { {
        "rvm"            => ["2.0.0"],
        "gemfile"        => ["Gemfile"],
        "before_script"  => ["echo before_script"],
        "cache"          => {
          "directories"=>["~/.cache"]
        },
        "before_install" => ["echo before_install"],
        "script"         => ["RAILS_ENV=test ls -1 && echo DONE!"],
        "env" => {
          "matrix" => [],
          "global" => []
        }
      } }

      context "from_yaml" do
        subject { described_class.from_yaml(fixture('travis.yml')).attributes }
        it { should eq expected }
      end

      context "form_file" do
        subject { described_class.from_file('spec/fixtures/travis.yml').attributes }
        it { should eq expected }
      end

      context "from_attributes" do
        let(:attrs) {{
          rvm:           "2.0.0",
          gemfile:       "Gemfile",
          before_script: "echo before_script",
          before_install: "echo before_install",
          script:        "RAILS_ENV=test ls -1 && echo DONE!",
          cache: {
            "directories" => ["~/.cache"]
          }
        }}
        subject { described_class.from_attributes(attrs).attributes }
        it { should eq expected }
      end
    end

    context ".to_yaml" do
      subject { config.to_yaml }
      it { should eq config.attributes.to_yaml }
    end
  end

  context "to_matrix_s" do
    subject { config.to_matrix_s }
    it { should eq 'gemfile:Gemfile, rvm:2.0.0' }

    context "when many items" do
      before do
        mock(config).rvm { %w{ 1.9.3 2.0.0 } }
        mock(config).scala { %w{ 2.10.1 } }
      end
      it { should eq "gemfile:Gemfile, rvm:1.9.3, scala:2.10.1" }
    end
  end

  context "matrix_keys" do
    subject { config.matrix_keys }
    it { should eq("rvm" => "2.0.0", "gemfile" => "Gemfile") }

    context "when many items" do
      before do
        mock(config).rvm { %w{ 1.9.3 2.0.0 } }
        mock(config).scala { %w{ 2.10.1 } }
      end
      it { should eq({"rvm"=>"1.9.3", "scala"=>"2.10.1", "gemfile" => "Gemfile"}) }
    end
  end


  it "empty attributes must be empty Array" do
    expect(config.scala).to eq([])
  end

  context "normalize_attributes" do
    described_class::AS_ARRAY.each do |m|
      context "convert #{m} attribute to Array" do
        let(:content) { { m => m } }
        subject { config.__send__(m) }
        it { should eq([m]) }
      end
    end

    context "convert hash keys to strings" do
      let(:content) { { rvm: "rvm" } }
      subject { config.attributes }
      it { should include("rvm" => %w{rvm}) }
    end

    context "build env hash" do
      subject { config.attributes["env"] }

      context "from String" do
        let(:content) { { env: "FOO" } }
        it { should eq( "global" => [], "matrix" => %w{ FOO } ) }
      end

      context "from Array" do
        let(:content) { { env: %w{ FOO BAR } } }
        it { should eq( 'global' => [], 'matrix' => %w{ FOO BAR } ) }
      end

      context "from empty Hash" do
        let(:content) { { env: {} } }
        it { should eq( 'global' => [], 'matrix' => [] ) }
      end

      context "from Hash" do
        let(:content) { { env: { "global" => "1", 'matrix' => '2' } } }
        it { should eq( 'global' => %w{1}, 'matrix' => %w{2} ) }
      end
    end
  end

  context "env" do
    let(:content) { { env: env } }
    subject { config.env }

    context "when attributes[env] is Array" do
      let(:env) { %w{ FOO=1 BAR=2 } }
      it { should eq("matrix"=>["FOO=1", "BAR=2"], "global"=>[]) }
    end

    context "when attributes[env] is Hash" do
      let(:env) { { "matrix" => %w{ BAZ=1 } } }
      it { should eq("matrix"=>["BAZ=1"], "global"=>[]) }
    end

    context "when attributes[env] is empty" do
      let(:env) { {} }
      it { should eq("matrix"=>[], "global"=>[]) }
    end
  end

  context "global_env" do
    let(:content) { { env: env } }
    subject { config.global_env }

    context "when attributes[env] is Array" do
      let(:env) { %w{ FOO=1 } }
      it { should eq([]) }
    end

    context "when attributes[env] is Hash" do
      let(:env) { { "global" => %w{ FOO=1 } } }
      it { should eq %w{ FOO=1 } }
    end

    context "when attributes[env] is empty" do
      let(:env) { {} }
      it { should eq([]) }
    end
  end

  context "services" do
    subject { config.services }
    let(:content) { { services: 'service' } }
    it { should eq ['service'] }
  end

end
