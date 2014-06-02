require 'hashr'

module Vx
  module Builder
    class Configuration < ::Hashr

      extend Hashr::EnvDefaults

      self.env_namespace      = 'vx'
      self.raise_missing_keys = true

      define casher_ruby: "/opt/rbenv/versions/1.9.3-p547/bin/ruby"

    end
  end
end
