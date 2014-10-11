require 'spec_helper'
require 'fileutils'
require 'tempfile'
require 'yaml'

describe "(integration) ruby" do
  let(:path) { Dir.tmpdir + "/vx-builder-test" }

  before do
    FileUtils.rm_rf(path)
    FileUtils.mkdir_p(path)
  end

  after { FileUtils.rm_rf(path) }

  def write_script_to_filter(prefix, script)
=begin
    File.open(fixture_path("integration/ruby/#{prefix}before_script.sh"), 'w') do |io|
      io << script.to_before_script
    end
    File.open(fixture_path("integration/ruby/#{prefix}after_script.sh"), 'w') do |io|
      io << script.to_after_script
    end
    File.open(fixture_path("integration/ruby/#{prefix}script.sh"), 'w') do |io|
      io << script.to_script
    end
=end
  end

  def build(file, options = {})
    config = file ? Vx::Builder::BuildConfiguration.from_yaml(file) : Vx::Builder::BuildConfiguration.new(nil)
    matrix = Vx::Builder.matrix config
    options[:task] ||= create(:task)
    rs = OpenStruct.new matrix: matrix, scripts: []
    matrix.build.each do |b|
      rs.scripts << Vx::Builder.script(options[:task], b)
    end
    rs
  end

  context "generation" do
    let(:config) { fixture("integration/ruby/language/config.yml") }

    it "should successfuly generate scripts using language: ruby" do
      c = fixture("integration/ruby/language/config.yml")
      b = build(c)
      expect(b.scripts).to have(1).item
      script = b.scripts[0]
      write_script_to_filter("language/", script)
      expect(script.to_before_script).to eq fixture("integration/ruby/language/before_script.sh")
      expect(script.to_script).to        eq fixture("integration/ruby/language/script.sh")
      expect(script.to_after_script).to  eq fixture("integration/ruby/language/after_script.sh")
    end

    it "should successfuly generate scripts for deploy" do
      c = fixture("integration/ruby/deploy/config.yml")
      b = build(c)
      expect(b.scripts).to have(1).item
      script = b.scripts[0]
      write_script_to_filter("deploy/", script)
      expect(script.to_before_script).to eq fixture("integration/ruby/deploy/before_script.sh")
      expect(script.to_script).to        eq fixture("integration/ruby/deploy/script.sh")
      expect(script.to_after_script).to  eq fixture("integration/ruby/deploy/after_script.sh")
    end

    it "should successfuly generate scripts for rvm matrix" do
      c = fixture("integration/ruby/matrix/config.yml")
      b = build(c)

      expect(b.scripts).to have(2).items

      script = b.scripts[0]
      write_script_to_filter("matrix/0.", script)

      expect(script.to_before_script).to eq fixture("integration/ruby/matrix/0.before_script.sh")
      expect(script.to_script).to        eq fixture("integration/ruby/matrix/0.script.sh")
      expect(script.to_after_script).to  eq fixture("integration/ruby/matrix/0.after_script.sh")

      script = b.scripts[1]
      write_script_to_filter("matrix/1.", script)

      expect(script.to_before_script).to eq fixture("integration/ruby/matrix/1.before_script.sh")
      expect(script.to_script).to        eq fixture("integration/ruby/matrix/1.script.sh")
      expect(script.to_after_script).to  eq fixture("integration/ruby/matrix/1.after_script.sh")

      deploy = Vx::Builder.deploy(b.matrix, branch: "master").build
      expect(deploy).to have(1).item

      script = Vx::Builder.script(create(:task), deploy[0])
      write_script_to_filter("matrix/d.", script)

      expect(script.to_before_script).to eq fixture("integration/ruby/matrix/d.before_script.sh")
      expect(script.to_script).to        eq fixture("integration/ruby/matrix/d.script.sh")
      expect(script.to_after_script).to  eq fixture("integration/ruby/matrix/d.after_script.sh")
    end
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
        io.write b.scripts[0].to_before_script
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
        io.write b.scripts[0].to_before_script
        io.write b.scripts[0].to_script
      end
      system("env", "-", "USER=$USER", "HOME=#{path}", "bash", "script.sh" )
      expect($?.to_i).to eq 0
    end
  end

  it "should succesfuly run lang/ruby with auto build", real: true do
    task = create(
      :task,
      sha: "HEAD",
      branch: "lang/ruby"
    )

    b = build(nil, task: task)
    Dir.chdir(path) do
      File.open("script.sh", "w") do |io|
        io.write "set -e\n"
        io.write b.scripts[0].to_before_script
        io.write b.scripts[0].to_script
      end
      system("env", "-", "USER=$USER", "HOME=#{path}", "bash", "script.sh" )
      expect($?.to_i).to eq 0
    end
  end

  it "should succesfuly run lang/ruby-rails-pg with auto build", real: true do
    task = create(
      :task,
      sha: "HEAD",
      branch: "lang/ruby-rails-pg"
    )

    b = build(nil, task: task)
    Dir.chdir(path) do
      File.open("script.sh", "w") do |io|
        io.write "set -e\n"
        io.write b.scripts[0].to_before_script
        io.write b.scripts[0].to_script
      end
      system("env", "-", "USER=$USER", "HOME=#{path}", "bash", "script.sh" )
      expect($?.to_i).to eq 0
    end
  end

  it "should succesfuly run lang/ruby-rails-mysql with auto build", real: true do
    task = create(
      :task,
      sha: "HEAD",
      branch: "lang/ruby-rails-mysql"
    )

    b = build(nil, task: task)
    Dir.chdir(path) do
      File.open("script.sh", "w") do |io|
        io.write "set -e\n"
        io.write b.scripts[0].to_before_script
        io.write b.scripts[0].to_script
      end
      system("env", "-", "USER=$USER", "HOME=#{path}", "bash", "script.sh" )
      expect($?.to_i).to eq 0
    end
  end
end
