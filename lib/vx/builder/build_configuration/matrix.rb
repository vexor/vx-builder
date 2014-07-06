module Vx
  module Builder
    class BuildConfiguration
      class Matrix

        attr_reader :attributes

        def initialize(new_env)
          normalize_attributes(new_env)
        end

        def exclude
          @attributes["exclude"] || []
        end

        private

          def normalize_attributes(new_env)
            @attributes = {}

            if new_env.is_a?(Hash)
              exclude = extract_exclude(new_env)
              @attributes.merge!("exclude" => exclude) if exclude
            end
          end

          def extract_exclude(env)
            case env['exclude']
            when Hash
              [env['exclude']]
            when Array
              env['exclude'].select{|i| i.is_a?(Hash) }
            end
          end

      end
    end
  end
end
