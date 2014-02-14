module Vx
  module Builder
    class BuildConfiguration
      class Deploy

        attr_reader :attributes

        def initialize(new_env)
          normalize_attributes(new_env)
        end

        def attributes
          @attributes
        end

        def providers
          @providers ||= @attributes.map do |a|
            Deploy::Provider.new(a)
          end
        end

        private

          def normalize_attributes(new_env)
            attrs =
              case new_env
              when Array
                new_env
              when Hash
                [new_env]
              when String
                [new_env]
              else
                []
              end

            extract_options_and_normalize_items(attrs)
          end

          def extract_options_and_normalize_items(new_env)
            @attributes = []
            new_env.each do |env|
              case env
              when Hash
                if env["provider"]
                  @attributes.push env
                else
                  @attributes.push env.merge("provider" => "shell")
                end
              when String
                @attributes.push("provider" => "shell", "command" => env)
              end
            end
          end

      end
    end
  end
end

