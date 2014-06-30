module Vx
  module Builder
    class BuildConfiguration
      class Vexor

        attr_reader :attributes

        def initialize(new_attributes)
          normalize_attributes(new_attributes)
        end

        def timeout
          tm = @attributes["timeout"].to_i
          tm.to_i > 0 ? tm.to_i : nil
        end

        def read_timeout
          tm = @attributes["read_timeout"].to_i
          tm.to_i > 0 ? tm.to_i : nil
        end

        private

          def normalize_attributes(new_attributes)
            @attributes =
              case new_attributes
              when Hash
                {
                  "timeout"      => new_attributes["timeout"],
                  "read_timeout" => new_attributes["read_timeout"],
                }
              else
                {}
              end

          end

      end
    end
  end
end
