module Vx
  module Builder
    class BuildConfiguration
      class Cache

        attr_reader :attributes

        def initialize(new_cache)
          normalize_attributes(new_cache)
        end

        def directories
          @attributes["directories"]
        end

        def enabled?
          @attributes["enabled"]
        end

        private

          def normalize_attributes(new_cache)

            @attributes =
              case new_cache
              when nil
                {
                  "directories" => [],
                  "enabled"     => true,
                }
              when Hash
                {
                  "directories" => Array(new_cache["directories"]).flatten.map(&:to_s),
                  "enabled"     => true,
                }
              else
                {
                  "directories" => [],
                  "enabled"     => false
                }
              end

          end

      end
    end
  end
end
