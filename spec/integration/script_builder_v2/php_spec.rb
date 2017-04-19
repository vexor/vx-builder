require 'spec_helper'
require 'yaml'
require 'tmpdir'
require 'fileutils'

describe "(integration v2) php" do
  let(:path) { Dir.tmpdir + "/vx-builder-test" }

  before do
    FileUtils.rm_rf(path)
    FileUtils.mkdir_p(path)
  end
  after { FileUtils.rm_rf(path) }

  def build(file, options = {})
    config = Vx::Builder::BuildConfiguration.from_yaml(file)
    matrix = Vx::Builder.matrix config
    options[:task] ||= create(:task)
    script = Vx::Builder.script_v2(options[:task], matrix.build.first)
    OpenStruct.new script: script, matrix: matrix
  end

  it "should generate valid yaml" do
    file = {"language" => "php"}.to_yaml
    task = create(
      :task,
      sha: "HEAD",
      branch: "lang/php"
    )

    b = build(file, task: task)
    s = b.script.to_yaml
    expect(s).to match(/vxvm: php 7\.1/)
  end
end
