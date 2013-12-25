require 'yaml'
require 'json'

module Vx
  module Builder
    class BuildConfiguration

      module Serializable

        def self.included(base)
          base.extend ClassMethods
        end

        def to_yaml
          YAML.dump(attributes)
        end

        def to_hash
          attributes
        end

        module ClassMethods

          def from_file(file)
            if File.readable? file
              from_yaml File.read(file)
            end
          end

          def from_yaml(yaml)
            from_attributes YAML.load(yaml)
          end

          def from_attributes(attrs)
            BuildConfiguration.new attrs
          end

        end

      end
    end
  end
end
