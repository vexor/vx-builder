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

        FLAT_ATTRIBUTES = %w{
          rvm
          gemfile
          scala
          jdk
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

        def merge(deploy_modules, base_build_configuration)
          hash = base_build_configuration.to_hash

          BLACK_LIST.each do |attr|
            hash.delete(attr)
          end

          hash["env"]            = base_build_configuration.env.global
          hash["deploy_modules"] = deploy_modules
          BuildConfiguration.new(hash)
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

