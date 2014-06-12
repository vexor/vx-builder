module Vx
  module Builder
    class BuildConfiguration
      class Deploy

        attr_reader :attributes

        def initialize(new_env)
          normalize(new_env)
        end

        def attributes
          @attributes
        end

        def find_modules(branch)
          modules = []
          Base.loaded.each do |l|
            attributes.each do |attr|
              if l.detect(attr)
                modules << l.new(attr)
              end
            end
          end
          modules.select{ |m| m.branch?(branch) }
        end

        private

          def normalize(new_env)
            attrs =
              case new_env
              when Array
                new_env
              when Hash
                [new_env]
              else
                []
              end

            normalize_each(attrs)
          end

          def normalize_each(new_env)
            @attributes = []
            @attributes = new_env.select{|i| i.is_a?(Hash) }
          end

      end
    end
  end
end

