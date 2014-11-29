require 'spec_helper'

describe Vx::Builder::ScriptBuilderV2 do
  let(:task)   { create :task }
  let(:source) { create :source }
  let(:script) { described_class.new task, source }
  subject { script }

  context "just created" do
    its(:source) { should eq source }
    its(:task)   { should eq task  }
  end

  it "should avaialble timeout and read_timeout attributes" do
    expect(script.vexor.timeout).to eq 10
    expect(script.vexor.read_timeout).to eq 20

    simple_source = create :source, name: "simple.yml"
    simple_script = described_class.new task, simple_source
    expect(simple_script.vexor.timeout).to be_nil
    expect(simple_script.vexor.read_timeout).to be_nil
  end

  it "should create parallel jobs" do
    matrix = Vx::Builder::MatrixBuilder.new(source)
    configurations = matrix.build
    configuration = configurations[1]
    expect(configuration.parallel).to eq 3
    expect(configuration.parallel_job_number).to eq 1
    parallel_script = described_class.new task, configuration

    parallel_script.to_hash # call
    stage = parallel_script.stage("init")
    expect(stage.environment["CI_PARALLEL_JOBS"]).to eq 3
    expect(stage.environment["CI_PARALLEL_JOB_NUMBER"]).to eq 1
  end

  it "should able to convert to yaml" do
    yml = script.to_yaml
    fixture = "spec/fixtures/script_builder_v2/simple.yml"
    File.open(fixture, 'w') { |io| io.write yml }
    expect(script.to_yaml).to eq File.read(fixture)
  end

  it "should able to convert to script" do
    sh = script.to_script
    fixture = "spec/fixtures/script_builder_v2/simple.sh"
    File.open(fixture, 'w') { |io| io.write sh }
    expect(script.to_script).to be
  end

end
