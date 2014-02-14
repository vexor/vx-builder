module Vx
  module Builder
    class BuildConfiguration
      class Deploy

        class On

          attr_reader :attributes, :branch

          def initialize(new_attributes)
            normalize(new_attributes)
          end

          def to_hash
            attributes.merge("branch" => branch)
          end

          private

            def normalize(new_attributes)
              @attributes = {}
              @branch = []

              case new_attributes
              when String
                @branch = [new_attributes]
              when Hash
                new_attributes = new_attributes.inject({}) do |a, pair|
                  k,v = pair
                  a[k] = v.is_a?(Array) ? v.map(&:to_s) : [v.to_s]
                  a
                end
                @branch = new_attributes.delete("branch") || []
                @attributes = new_attributes
              when Array
                @branch = new_attributes.map(&:to_s)
              end

              @attributes.delete("condition")
              @attributes.delete("all_branches")
              @attributes.delete("tags")
              @attributes.delete("repo")
            end

        end

      end
    end
  end
end
