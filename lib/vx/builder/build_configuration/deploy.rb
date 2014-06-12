module Vx
  module Builder
    class BuildConfiguration
      class Deploy

        BLACK_LIST = %w{
          image
          before_script
          after_script
          script
        }

        attr_reader :attributes

        def initialize(new_env)
          normalize(new_env)
        end

        def attributes
          @attributes
        end

        def find(branch)
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

        def build(deploy_modules, base_build_configuration)
          base_build_configuration.remove_keys BLACK_LIST

          base_build_configuration.env.reset_matrix
          BuildConfiguration.new(
            base_build_configuration.to_hash.merge(
              "deploy_modules" => deploy_modules
            )
          )
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

