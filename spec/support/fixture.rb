def fixture(name)
  File.read fixture_path(name)
end

def fixture_path(name)
  File.expand_path("../../fixtures/#{name}", __FILE__)
end
