require 'spec_helper'
require 'yaml'

describe Vx::Builder::Matrix do
  let(:attributes) { {
    "env"            => %w{ FOO=1 BAR=2 },
    "rvm"            => %w{ 1.8.7 1.9.3 2.0.0 },
    "scala"          => %w{ 2.9.2 2.10.1 },
    "before_script"  => "echo before_script",
    "before_install" => "echo before_install",
    "script"         => "echo script",
  } }
  let(:config) { Vx::Builder::BuildConfiguration.new attributes }
  let(:matrix) { described_class.new config }

  subject { matrix }

  context "just created" do
    its(:build_configuration) { should eq config }
  end

  context "keys" do
    subject { matrix.keys }

    it { should eq %w{ env rvm scala } }

    context "without matrix" do
      let(:attributes) { {} }
      it { should eq [] }
    end
  end

  context "deploy_configuration" do
    let(:branch) { 'master' }
    subject { matrix.deploy_configuration branch }

    it "should be nil without :deploy key" do
      expect(subject).to be_nil
    end

    context "with single deploy without condifitions" do
      let(:attributes) { {
        "deploy" => "cap deploy production"
      } }

      it { should be }
      its("deploy.attributes"){ should eq(
        [{"command"=>"cap deploy production", "provider"=>"shell", "branch"=>[]}]
      ) }
    end

    context "with single deploy and condititions" do
      let(:attributes) { {
        "deploy" => {
          "command" => "cap deploy production",
          "branch" => ["master"]
        }
      } }

      it { should be }
      its("deploy.attributes"){ should eq(
        [{"command"=>"cap deploy production", "provider"=>"shell", "branch"=>["master"]}]
      ) }
    end

    context "with multiple deploys and condititions" do
      let(:attributes) { {
        "deploy" => [
          {
            "command" => "cap deploy staging",
            "branch" => ["master"]
          },
          {
            "command" => "cap deploy production",
            "branch" => ["production"]
          }
         ]
      } }

      it { should be }
      its("deploy.attributes"){ should eq(
        [{"command"=>"cap deploy staging", "provider"=>"shell", "branch"=>["master"]}]
      ) }

      context "when no one matched" do
        let(:branch) { 'staging' }
        it { should be_nil }
      end
    end
  end

  context 'build_configurations' do

    subject { matrix.build_configurations }

    it { should have(12).items }

    it "should copy script from source" do
      expect(subject.map(&:script).flatten).to eq ["echo script"] * 12
    end

    it "should copy before_script from source" do
      expect(subject.map(&:before_script).flatten).to eq ["echo before_script"] * 12
    end

    it "should copy before_install from source" do
      expect(subject.map(&:before_install).flatten).to eq ["echo before_install"] * 12
    end

    context "without any matrix keys" do
      let(:attributes) { {
        "script" => %w{ /bin/true },
      } }

      it { should have(1).item }

      context "attributes" do
        subject { matrix.build_configurations.first.to_hash.select{|k,v| !v.empty? } }

        it { should eq(
          "env" => {
            "matrix" => [],
            "global" => []
          },
          "cache" => {
            "directories" => [],
            "enabled"     => true
          },
          "script" => ["/bin/true"]
        ) }
      end
    end

    context "with one :env and one :rvm key" do
      let(:config) { Vx::Builder::BuildConfiguration.from_file fixture_path("travis_bug_1.yml") }

      it "should have one :env and one :rvm key in matrix" do
        keys = subject.map{|c| c.to_hash.select{|k,v| !v.empty? } }
        expect(keys).to have(1).item

        expect(keys.first["rvm"]).to eq ['2.0.0']
        expect(keys.first['env']).to eq(
          "matrix" => ["DB=postgresql"],
          "global" => ["DB=postgresql"]
        )
      end
    end

    context "with :services key" do
      let(:config) { Vx::Builder::BuildConfiguration.from_file fixture_path("travis_bug_2.yml") }

      it "should have services in matrix" do
        expect(subject).to have(1).item
        expect(subject.first.services).to eq ['elasticsearch']
      end
    end

    context "attributes" do
      subject { matrix.build_configurations.map(&:matrix_id) }

      it "should have true values" do
        expect(subject).to eq [
          "env:BAR=2, rvm:1.8.7, scala:2.10.1",
          "env:FOO=1, rvm:1.8.7, scala:2.10.1",
          "env:BAR=2, rvm:1.8.7, scala:2.9.2",
          "env:FOO=1, rvm:1.8.7, scala:2.9.2",
          "env:BAR=2, rvm:1.9.3, scala:2.10.1",
          "env:FOO=1, rvm:1.9.3, scala:2.10.1",
          "env:BAR=2, rvm:1.9.3, scala:2.9.2",
          "env:FOO=1, rvm:1.9.3, scala:2.9.2",
          "env:BAR=2, rvm:2.0.0, scala:2.10.1",
          "env:FOO=1, rvm:2.0.0, scala:2.10.1",
          "env:BAR=2, rvm:2.0.0, scala:2.9.2",
          "env:FOO=1, rvm:2.0.0, scala:2.9.2"
        ]
      end

      context "with one matrix key" do
        let(:attributes) { {
          "rvm" => %w{ 2.0.0 },
        } }

        it { should eq ['rvm:2.0.0'] }
      end
    end
  end

  context "attributes_for_new_confgurations_with_merged_env" do
    subject { matrix.attributes_for_new_build_configurations_with_merged_env }

    before do
      attributes.merge!(
        "env" => {
          "global" => "FOO=1",
          "matrix" => %w{ BAR=1 BAR=2 }
        }
      )
    end

    it { should have(12).items }

    it "should merge matrix env to global env" do
      expect(subject.map{|i| i["env"]["global"] }.uniq.sort).to eq([["BAR=1", "FOO=1"], ["BAR=2", "FOO=1"]])
    end
  end

  context 'attributes_for_new_build_configurations' do
    subject { matrix.attributes_for_new_build_configurations }

    it { should have(12).items }

    its(:first) { should eq("rvm"   => "1.8.7",
                            "scala" => "2.10.1",
                            "env"   => "BAR=2") }
    its(:last)  { should eq("rvm"   => "2.0.0",
                            "scala" => "2.9.2",
                            "env"   => "FOO=1") }
  end

  context 'extract_keys_from_builds_configuration' do
    subject { matrix.extract_keys_from_builds_configuration }
    it {
      should eq [
        ["rvm",   %w{ 1.8.7 1.9.3 2.0.0 }],
        ["scala", %w{ 2.9.2 2.10.1 }],
        ["env",   %w{ FOO=1 BAR=2 }]
      ]
    }
  end

  context "permutate_and_build_pairs" do
    subject { format_values matrix.permutate_and_build_pairs }
    let(:expected) { [
      %w{env:BAR=2 rvm:1.8.7 scala:2.10.1},
      %w{env:BAR=2 rvm:1.8.7 scala:2.9.2},
      %w{env:BAR=2 rvm:1.9.3 scala:2.10.1},
      %w{env:BAR=2 rvm:1.9.3 scala:2.9.2},
      %w{env:BAR=2 rvm:2.0.0 scala:2.10.1},
      %w{env:BAR=2 rvm:2.0.0 scala:2.9.2},
      %w{env:FOO=1 rvm:1.8.7 scala:2.10.1},
      %w{env:FOO=1 rvm:1.8.7 scala:2.9.2},
      %w{env:FOO=1 rvm:1.9.3 scala:2.10.1},
      %w{env:FOO=1 rvm:1.9.3 scala:2.9.2},
      %w{env:FOO=1 rvm:2.0.0 scala:2.10.1},
      %w{env:FOO=1 rvm:2.0.0 scala:2.9.2},
    ] }

    it { should eq expected }

    context "with empty keys" do
      let(:attributes) { {
        "env"   => %w{ FOO=1 BAR=2 },
        "rvm"   => %w{ 1.8.7 1.9.3 2.0.0 },
        "scala" => %w{ 2.9.2 2.10.1 },
        "java"  => [],
      } }
      it { should eq expected }
    end

    context "with one key" do
      let(:attributes) { {
        "rvm" => %w{ 1.9.3 2.0.0 },
      } }
      let(:expected) {[
        %w{ rvm:1.9.3 },
        %w{ rvm:2.0.0 }
      ]}
      it { should eq expected }
    end

    context "without matrix" do
      let(:attributes) { {
        "rvm" => %w{ 2.0.0 },
      } }
      let(:expected) {[
        %w{ rvm:2.0.0 }
      ]}
      it { should eq expected }
    end

    def format_values(values)
      values.map{|i| i.map(&:to_s).sort }.sort
    end
  end
end
