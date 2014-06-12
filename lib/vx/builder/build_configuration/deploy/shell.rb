require File.expand_path("../base", __FILE__)

module Vx
  module Builder
    class BuildConfiguration
      class Deploy

        class Shell < Base

          provide :shell

          def to_commands
            key.map(&:to_s)
          end

        end

      end
    end
  end
end
