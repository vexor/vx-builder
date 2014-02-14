module Vx
  module Builder
    class BuildConfiguration
      class Deploy

        class Provider

          attr_reader :name, :options, :on

          def initialize(new_attributes)
            normalize_attributes new_attributes.dup
          end

          def on?(build_configuration)
            config_attrs = build_configuration.to_hash
            on.attributes.each do |attribute_name, values|
              if config_values = config_attrs[attribute_name]
                values.all? do |v|
                  config_values.include?(v)
                end
              end
            end
          end

          def on_branch?(branch)
            return true if on.branch.empty?
            on.branch.include?(branch)
          end

          def to_hash
            options.merge(
              "provider" => @name,
              "on"       => on.to_hash
            )
          end

          private

            def normalize_attributes(new_attributes)
              @name    = new_attributes.delete("provider")
              @on      = On.new(new_attributes.delete("on"))
              @options = new_attributes
            end

        end

      end
    end
  end
end
