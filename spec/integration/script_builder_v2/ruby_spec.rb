require 'spec_helper'
require 'fileutils'
require 'tempfile'
require 'yaml'

describe "(integration v2) ruby" do
  let(:path) { Dir.tmpdir + "/vx-builder-test" }

  before do
    FileUtils.rm_rf(path)
    FileUtils.mkdir_p(path)
  end

  after { FileUtils.rm_rf(path) }

  def build(file, options = {})
    config = file ? Vx::Builder::BuildConfiguration.from_yaml(file) : Vx::Builder::BuildConfiguration.new(nil)
    matrix = Vx::Builder.matrix config
    options[:task] ||= create(:task)
    rs = OpenStruct.new matrix: matrix, scripts: []
    matrix.build.each do |b|
      rs.scripts << Vx::Builder.script_v2(options[:task], b)
    end
    rs
  end

  it "should succesfuly run lang/ruby", real: true do
    file = {"language" => "ruby"}.to_yaml
    task = create(
      :task,
      sha: "HEAD",
      branch: "lang/ruby"
    )

    b = build(file, task: task)
    Dir.chdir(path) do
      File.open("script.sh", "w") do |io|
        io.write "set -e\n"
        io.write b.scripts[0].to_script
      end
      system("env", "-", "USER=$USER", "HOME=#{path}", "bash", "script.sh" )
      expect($?.to_i).to eq 0
    end
  end

  it "should fail to run lang/ruby", real: true do
    file = {"language" => "ruby", "script" => "false"}.to_yaml
    task = create(
      :task,
      sha: "HEAD",
      branch: "lang/ruby"
    )

    b = build(file, task: task)
    Dir.chdir(path) do
      File.open("script.sh", "w") do |io|
        io.write "set -e\n"
        io.write b.scripts[0].to_script
      end
      system("env", "-", "USER=$USER", "HOME=#{path}", "bash", "script.sh" )
      expect($?.to_i).to_not eq 0
    end
  end

  it "should succesfuly run lang/ruby with rvm key", real: true do
    file = {"rvm" => "2.1"}.to_yaml
    task = create(
      :task,
      sha: "HEAD",
      branch: "lang/ruby"
    )

    b = build(file, task: task)
    Dir.chdir(path) do
      File.open("script.sh", "w") do |io|
        io.write "set -e\n"
        io.write b.scripts[0].to_script
      end
      system("env", "-", "USER=$USER", "HOME=#{path}", "bash", "script.sh" )
      expect($?.to_i).to eq 0
    end
  end

  it "should succesfuly run lang/ruby with parallel_rspec", real: true do
    file = {"language" => "ruby", "parallel" => 3, "script" => "parallel_rspec"}.to_yaml
    task = create(
      :task,
      sha: "HEAD",
      branch: "lang/ruby"
    )

    b = build(file, task: task)
    Dir.chdir(path) do
      File.open("script.sh", "w") do |io|
        io.write "set -e\n"
        io.write b.scripts[0].to_script
      end
      system("env", "-", "USER=$USER", "HOME=#{path}", "bash", "script.sh" )
      expect($?.to_i).to eq 0
    end
  end

  it "should succesfuly run lang/ruby-rails-pg", real: true do
    file = {"language" => "ruby"}.to_yaml
    task = create(
      :task,
      sha: "HEAD",
      branch: "lang/ruby-rails-pg"
    )

    b = build(file, task: task)
    Dir.chdir(path) do
      File.open("script.sh", "w") do |io|
        io.write "set -e\n"
        io.write b.scripts[0].to_script
      end
      system("env", "-", "USER=$USER", "HOME=#{path}", "bash", "script.sh" )
      expect($?.to_i).to eq 0
    end
  end

  it "should succesfuly run lang/ruby-rails-mysql", real: true do
    file = {"language" => "ruby"}.to_yaml
    task = create(
      :task,
      sha: "HEAD",
      branch: "lang/ruby-rails-mysql"
    )

    b = build(file, task: task)
    Dir.chdir(path) do
      File.open("script.sh", "w") do |io|
        io.write "set -e\n"
        io.write b.scripts[0].to_script
      end
      system("env", "-", "USER=$USER", "HOME=#{path}", "bash", "script.sh" )
      expect($?.to_i).to eq 0
    end
  end
end

