def create(name, options = {})
  case name
  when :task
    Vx::Builder::Task.new(
      'name',
      'src',
      'sha',
      deploy_key: 'deploy_key',
      branch: 'master'
    )
  when :source
    Vx::Builder::Source.from_yaml(fixture("travis.yml"))
  end
end
