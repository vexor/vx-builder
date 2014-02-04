module Vx
  module Builder
    class Source

      LANGS    = %w{ rvm scala java go }.freeze
      KEYS     = %w{ gemfile services before_script script before_install }.freeze
      AS_ARRAY = (KEYS + LANGS).freeze

    end
  end
end
