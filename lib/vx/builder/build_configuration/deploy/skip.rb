require File.expand_path("../base", __FILE__)

module Vx
  module Builder
    class BuildConfiguration
      class Deploy

        class Skip < Base

          provide :skip

          def rate
            2**32 - 1 
          end

          def to_commands
            key.map(&:to_s)
          end

          def call(stage)
            if skipped_stages.include?(stage.name)
              stage.clean_tasks!
              stage.add_task("shell", "echo \"----> Skipped by user config in DEPLOY stage...\"")
            end
          end

          private

          def skipped_stages
            Array(params["skip"])
          end

        end

      end
    end
  end
end
