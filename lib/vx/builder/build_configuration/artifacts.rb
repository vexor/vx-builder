module Vx
  module Builder
    class BuildConfiguration
      class Artifacts

        attr_reader :attributes

        def initialize(new_env)
          normalize_attributes(new_env)
        end

        def attributes
          @attributes
        end

        def files
          @files
        end

        def prefix
          @options[:prefix]
        end

        private

          def normalize_attributes(new_env)
            attrs =
              case new_env
              when Array
                new_env
              else
                Array(new_env)
              end

            extract_options_and_normalize_items(attrs)
          end

          def extract_options_and_normalize_items(new_env)
            opts = {}
            @attributes = []
            @files      = []
            env = new_env.inject([]) do |a, e|
              if e.is_a?(Hash)
                opts = e
                @attributes.push e
              else
                a.push e.to_s.gsub(/^\.*(\/)/, '')
                @attributes.push a.last
                @files.push a.last
              end
              a
            end

            if opts && opts["prefix"]
              @options = { prefix: opts["prefix"] }
            else
              @options = {}
            end

            [opts, env]

          end

      end
    end
  end
end

