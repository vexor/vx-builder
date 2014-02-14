module Vx
  module Builder
    class BuildConfiguration
      class Env

        attr_reader :attributes

        def initialize(new_env)
          normalize_attributes(new_env)
        end

        def matrix
          @attributes["matrix"]
        end

        def global
          @attributes["global"]
        end

        private

          def normalize_attributes(new_env)

            @attributes =
              case new_env
              when Hash
                {
                  "matrix" => Array(new_env['matrix']),
                  "global" => Array(new_env['global'])
                }
              else
                {
                  "matrix" => Array(new_env).flatten.map(&:to_s),
                  "global" => []
                }
              end

          end

      end
    end
  end
end