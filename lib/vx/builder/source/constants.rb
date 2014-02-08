module Vx
  module Builder
    class Source

      LANGS    = %w{ rvm scala java go }.freeze
      KEYS     = %w{ gemfile services before_script script before_install image }.freeze
      AS_ARRAY = (KEYS + LANGS).freeze

    end
  end
end
