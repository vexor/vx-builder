module Vx
  module Builder
    class BuildConfiguration
      class Artifacts

        attr_reader :attributes

        def initialize(new_env)
          normalize_attributes(new_env)
        end

        def artifacts
          @attributes
        end

        private

          def normalize_attributes(new_env)

            @attributes =
              case new_env
              when Array
                new_env.map(&:to_s)
              else
                Array(new_env).map(&:to_s)
              end

            @attributes.map! do |attr|
              attr.gsub(/^\.*(\/)/, '')
            end

          end

      end
    end
  end
end

