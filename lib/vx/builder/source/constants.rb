module Vx
  module Builder
    class Source

      LANGS    = %w{ rvm scala jdk }.freeze
      KEYS     = %w{ gemfile services before_script script before_install image
                     after_success }.freeze
      AS_ARRAY = (KEYS + LANGS).freeze

    end
  end
end
