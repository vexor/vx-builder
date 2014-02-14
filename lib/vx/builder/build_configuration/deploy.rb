module Vx
  module Builder
    class BuildConfiguration
      class Deploy

        attr_reader :attributes

        def initialize(new_env)
          normalize_attributes(new_env)
        end

        def providers
          @providers
        end
        alias :attributes :providers

        private

          def normalize_attributes(new_env)
            attrs =
              case new_env
              when Array
                new_env
              when Hash
                [new_env]
              when String
                [{"command" => new_env}]
              else
                []
              end

            extract_options_and_normalize_items(attrs)
          end

          def extract_options_and_normalize_items(new_env)
            @providers = []
            new_env.each do |env|
              case
              when env["provider"]
                @providers.push env
              when env["command"]
                @providers.push env.merge("provider" => "shell")
              end
            end
          end

      end
    end
  end
end

