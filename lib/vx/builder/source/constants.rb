module Vx
  module Builder
    class Source

      LANGS    = %w{ rvm scala java }.freeze
      KEYS     = %w{ gemfile services before_script script before_install image
                     after_success }.freeze
      AS_ARRAY = (KEYS + LANGS).freeze

    end
  end
end
