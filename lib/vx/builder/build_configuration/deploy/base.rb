module Vx
  module Builder
    class BuildConfiguration
      class Deploy

        class Base

          @@loaded = []

          class << self

            def loaded
              @@loaded
            end

            def provide(val)
              @@loaded << self
              @key = val
            end

            def key
              @key
            end

            def queue(val = nil)
              @queue = val if val
              @queue || :default
            end

            def detect(params)
              params.key?(key) if key
            end

            def find(params)
              loaded.select{|i| i.detect params }.first
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

          def key
            if self.class.key
              Array(params[self.class.key.to_s])
            end
          end

          def to_commands
            nil
          end

          def queue
            self.class.queue
          end

        end

      end
    end
  end
end
