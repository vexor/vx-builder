require 'hashr'

module Vx
  module Builder
    class Configuration < ::Hashr

      extend Hashr::Env

      self.env_namespace      = 'vx'

      define casher_ruby: "casher-ruby"

    end
  end
end
