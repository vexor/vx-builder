module Vx
  module Builder
    class BuildConfiguration

      LANGS    = %w{ rvm scala java go }.freeze
      KEYS     = %w{ services before_script script }.freeze
      AS_ARRAY = (KEYS + LANGS).freeze

    end
  end
end
