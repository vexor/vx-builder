module Vx
  module Builder
    class Source

      LANGS    = %w{ rvm scala java go }.freeze
      KEYS     = %w{ services before_script script }.freeze
      AS_ARRAY = (KEYS + LANGS).freeze

    end
  end
end
