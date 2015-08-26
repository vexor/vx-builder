require 'spec_helper'
require 'yaml'
require 'tmpdir'
require 'fileutils'

describe "(integration v2) python" do
  let(:path) { Dir.tmpdir + "/vx-builder-test" }

  before do
    FileUtils.rm_rf(path)
    FileUtils.mkdir_p(path)
  end
  after do
    system "sudo rm -rf #{path}"
  end

  def build(file, options = {})
    config = Vx::Builder::BuildConfiguration.from_yaml(file)
    matrix = Vx::Builder.matrix config
    options[:task] ||= create(:task)
    scripts = matrix.build.map do |b|
      Vx::Builder.script_v2(options[:task], b)
    end
    OpenStruct.new scripts: scripts, matrix: matrix
  end

  it "should successfuly generate scripts" do
    file =<<-EOF
      python:
      - 2.7
      - 3.4
      install: pip install flake8
      script:
      - flake8 --max-line-length=120 .
      - py.test -v
    EOF
    task = create(:task, sha: "HEAD")
    b = build(file, task: task)
    one_script, two_script = b.scripts
    expect(one_script.to_yaml).to match(/python: '2\.7'/)
    expect(two_script.to_yaml).to match(/python: '3\.4'/)
  end

  it "should succesfuly run lang/python", real: true do
    file = {"language" => "python"}.to_yaml
    task = create(
      :task,
      sha: "HEAD",
      branch: "lang/python"
    )

    b = build(file, task: task)
    Dir.chdir(path) do
      File.open("script.sh", "w") do |io|
        io.write "set -e\n"
        io.write b.scripts.first.to_script
      end
      system("env", "-", "USER=#{ENV['USER']}", "HOME=#{path}", "bash", "script.sh" )
      expect($?.to_i).to eq 0
    end
  end
end
