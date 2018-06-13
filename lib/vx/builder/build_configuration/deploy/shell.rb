require File.expand_path("../base", __FILE__)

module Vx
  module Builder
    class BuildConfiguration
      class Deploy

        class Shell < Base
          PROCESSED_STAGES = %w(script)

          provide :shell

          def to_commands
            key.map(&:to_s)
          end

          def call(stage)
            if PROCESSED_STAGES.include?(stage.name)
              to_commands.each do |c|
                stage.add_task("shell", c)
              end
            end
          end

        end

      end
    end
  end
end
