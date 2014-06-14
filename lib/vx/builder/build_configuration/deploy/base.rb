module Vx
  module Builder
    class BuildConfiguration
      class Deploy

        class Base

          class << self

            @@loaded = []

            def loaded
              @@loaded
            end

            def provide(val)
              loaded.push self
              @key = val
            end

            def key
              @key
            end

            def detect(params)
              params.key?(key.to_s) if key
            end

            def module_by_key(val)
              loaded.find{|i| i.key.to_s == val.to_s }
            end
          end

          attr_reader :params, :branch

          def initialize(params)
            @params = params.is_a?(Hash) ? params : {}
            self.branch = params["branch"]
          end

          def branch=(value)
            @branch = Array(value).map(&:to_s)
          end

          def branch?(name)
            case
            when branch.empty?
              true
            when !name
              true
            else
              branch.include?(name)
            end
          end

          def key
            if self.class.key
              @key ||= Array(params[self.class.key.to_s])
            end
          end

          def to_hash
            if key
              { self.class.key.to_s => key }
            else
              {}
            end
          end

          def to_commands
            nil
          end

        end

      end
    end
  end
end
