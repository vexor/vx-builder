require 'spec_helper'
require 'yaml'

describe Vx::Builder::MatrixBuilder do
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

  context 'build' do

    subject { matrix.build }

    def create_matrix(attrs = nil)
      described_class.new(
        Vx::Builder::BuildConfiguration.new(attrs || attributes)
      ).build
    end

    it "should exclude configurations" do
      yaml = YAML.load %{
        env:
        - B=frontend
        - B=backend
        rvm:
        - 2.0
        - 2.1
        matrix:
          exclude:
          - rvm: 2.1
            env: B=frontend
      }
      configurations = create_matrix(yaml)
      expect(configurations).to have(3).items
      expect(configurations.map(&:rvm)).to eq [[2.0], [2.0], [2.1]]
      expect(configurations.map(&:env_matrix)).to eq [["B=backend"], ["B=frontend"], ["B=backend"]]
    end

    it "should generate parallel jobs" do
      yaml = YAML.load %{
        env:
          global:
          - FOO=BAR
          matrix:
          - B=frontend
          - B=backend
        rvm:
        - 2.0
        - 2.1
        parallel: 3
      }
      configurations = create_matrix(yaml)
      expect(configurations).to have(4 * 3).items
      parallel_attrs = [
        [{"matrix"=>["B=backend"],  "global"=>["FOO=BAR"]}, [2.0], 3, 0],
        [{"matrix"=>["B=backend"],  "global"=>["FOO=BAR"]}, [2.0], 3, 1],
        [{"matrix"=>["B=backend"],  "global"=>["FOO=BAR"]}, [2.0], 3, 2],
        [{"matrix"=>["B=frontend"], "global"=>["FOO=BAR"]}, [2.0], 3, 0],
        [{"matrix"=>["B=frontend"], "global"=>["FOO=BAR"]}, [2.0], 3, 1],
        [{"matrix"=>["B=frontend"], "global"=>["FOO=BAR"]}, [2.0], 3, 2],
        [{"matrix"=>["B=backend"],  "global"=>["FOO=BAR"]}, [2.1], 3, 0],
        [{"matrix"=>["B=backend"],  "global"=>["FOO=BAR"]}, [2.1], 3, 1],
        [{"matrix"=>["B=backend"],  "global"=>["FOO=BAR"]}, [2.1], 3, 2],
        [{"matrix"=>["B=frontend"], "global"=>["FOO=BAR"]}, [2.1], 3, 0],
        [{"matrix"=>["B=frontend"], "global"=>["FOO=BAR"]}, [2.1], 3, 1],
        [{"matrix"=>["B=frontend"], "global"=>["FOO=BAR"]}, [2.1], 3, 2]]
      expect(configurations.map{|i| [i.env.attributes, i.rvm, i.parallel, i.parallel_job_number] }).to eq parallel_attrs
    end

    it "should generate 12 configurations" do
      expect(create_matrix).to have(12).items
    end

    it "should copy script from source" do
      expect(subject.map(&:script).flatten).to eq ["echo script"] * 12
    end

    it "should copy before_script from source" do
      expect(subject.map(&:before_script).flatten).to eq ["echo before_script"] * 12
    end

    it "should copy before_install from source" do
      expect(subject.map(&:before_install).flatten).to eq ["echo before_install"] * 12
    end

    it "should assign matrix_attributes" do
      expect(subject.map(&:matrix_attributes).flatten).to have(12).items
    end

    it "should copy vexor attributes to all matrixes" do
      m = create_matrix("vexor" => {"timeout" => 20}, "rvm" => %w{ 2.1 2.0 })
      expect(m).to have(2).items
      expect(m.map(&:vexor).map(&:timeout)).to eq [20, 20]
    end

    it "should be empty if configuration is empty" do
      expect(create_matrix "deploy" => "value").to be_empty
    end

    context "without any matrix keys" do
      let(:attributes) { {
        "script" => %w{ /bin/true },
      } }

      it "should have one configuration" do
        expect(create_matrix).to have(1).item
      end

      it "should have valid attributes" do
        m = create_matrix
        m.map! do |c|
          c.to_hash.select{ |k,v|  !v.empty? }
        end
        expect(m).to eq([{
          "env" => {
              "matrix" => [],
              "global" => []
            },
          "cache" => {
            "directories" => [],
            "enabled"     => true
          },
          "script" => ["/bin/true"],
          "vexor"  => {"timeout"=>nil, "read_timeout"=>nil}
        }])
      end
    end

    context "with one :env and one :rvm key" do
      let(:config) { Vx::Builder::BuildConfiguration.from_file fixture_path("travis_bug_1.yml") }

      it "should have one :env and one :rvm key in matrix" do
        keys = subject.map{|c| c.to_hash.select{|k,v| !v.empty? } }
        expect(keys).to have(1).item

        expect(keys.first["rvm"]).to eq ['2.0.0']
        expect(keys.first['env']).to eq(
          "matrix" => [],
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
      subject { matrix.build.map(&:matrix_id) }

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

      context "with parallel" do
        before do
          attributes.merge!("parallel" => "3")
        end

        it "should have parallel key" do
          expect(matrix.build.map(&:matrix_id)).to eq [
           "env:BAR=2, parallel:0, rvm:1.8.7, scala:2.10.1",
           "env:BAR=2, parallel:1, rvm:1.8.7, scala:2.10.1",
           "env:BAR=2, parallel:2, rvm:1.8.7, scala:2.10.1",
           "env:FOO=1, parallel:0, rvm:1.8.7, scala:2.10.1",
           "env:FOO=1, parallel:1, rvm:1.8.7, scala:2.10.1",
           "env:FOO=1, parallel:2, rvm:1.8.7, scala:2.10.1",
           "env:BAR=2, parallel:0, rvm:1.8.7, scala:2.9.2",
           "env:BAR=2, parallel:1, rvm:1.8.7, scala:2.9.2",
           "env:BAR=2, parallel:2, rvm:1.8.7, scala:2.9.2",
           "env:FOO=1, parallel:0, rvm:1.8.7, scala:2.9.2",
           "env:FOO=1, parallel:1, rvm:1.8.7, scala:2.9.2",
           "env:FOO=1, parallel:2, rvm:1.8.7, scala:2.9.2",
           "env:BAR=2, parallel:0, rvm:1.9.3, scala:2.10.1",
           "env:BAR=2, parallel:1, rvm:1.9.3, scala:2.10.1",
           "env:BAR=2, parallel:2, rvm:1.9.3, scala:2.10.1",
           "env:FOO=1, parallel:0, rvm:1.9.3, scala:2.10.1",
           "env:FOO=1, parallel:1, rvm:1.9.3, scala:2.10.1",
           "env:FOO=1, parallel:2, rvm:1.9.3, scala:2.10.1",
           "env:BAR=2, parallel:0, rvm:1.9.3, scala:2.9.2",
           "env:BAR=2, parallel:1, rvm:1.9.3, scala:2.9.2",
           "env:BAR=2, parallel:2, rvm:1.9.3, scala:2.9.2",
           "env:FOO=1, parallel:0, rvm:1.9.3, scala:2.9.2",
           "env:FOO=1, parallel:1, rvm:1.9.3, scala:2.9.2",
           "env:FOO=1, parallel:2, rvm:1.9.3, scala:2.9.2",
           "env:BAR=2, parallel:0, rvm:2.0.0, scala:2.10.1",
           "env:BAR=2, parallel:1, rvm:2.0.0, scala:2.10.1",
           "env:BAR=2, parallel:2, rvm:2.0.0, scala:2.10.1",
           "env:FOO=1, parallel:0, rvm:2.0.0, scala:2.10.1",
           "env:FOO=1, parallel:1, rvm:2.0.0, scala:2.10.1",
           "env:FOO=1, parallel:2, rvm:2.0.0, scala:2.10.1",
           "env:BAR=2, parallel:0, rvm:2.0.0, scala:2.9.2",
           "env:BAR=2, parallel:1, rvm:2.0.0, scala:2.9.2",
           "env:BAR=2, parallel:2, rvm:2.0.0, scala:2.9.2",
           "env:FOO=1, parallel:0, rvm:2.0.0, scala:2.9.2",
           "env:FOO=1, parallel:1, rvm:2.0.0, scala:2.9.2",
           "env:FOO=1, parallel:2, rvm:2.0.0, scala:2.9.2"
          ]
        end
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

    it "should create environments" do
      expect(subject.map{|i| i["env"]["matrix"] }.uniq.sort).to eq([["BAR=1"], ["BAR=2"]])
      expect(subject.map{|i| i["env"]["global"] }.uniq.sort).to eq([["FOO=1"]])
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
