module Vx
  module Builder
    class BuildConfiguration
      class Deploy

        class Provider

          attr_reader :name, :options, :on

          def initialize(new_attributes)
            normalize new_attributes.dup
          end

          def branch?(branch)
            return true if on.empty?
            on.include?(branch)
          end

          def to_hash
            options.merge(
              "provider" => @name,
              "branch"   => on
            )
          end

          def shell?
            @name == 'shell'
          end

          def command
            Array(options["command"])
          end

          private

            def normalize(new_attributes)
              @name    = new_attributes.delete("provider")
              @on      = new_attributes.delete("branch")
              @options = new_attributes

              @on =
                case @on
                when String
                  [@on]
                when Array
                  @on.map(&:to_s)
                else
                  []
                end

            end

        end

      end
    end
  end
end
