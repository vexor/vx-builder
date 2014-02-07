require File.expand_path("../source/constants",    __FILE__)
require File.expand_path("../source/matrix",       __FILE__)
require File.expand_path("../source/serializable", __FILE__)

module Vx
  module Builder
    class Source

      include Source::Serializable

      attr_reader :attributes
      alias_method :to_hash, :attributes

      def initialize(attrs = {})
        @attributes = normalize_attributes attrs
      end

      def [](val)
        public_send(val)
      end

      def matrix_keys
        @matrix_keys ||=
          Matrix::KEYS.inject({}) do |a,k|
          k_method, k_name = k.split(":")
          k_name ||= k_method
          val = send(k_method)
          unless val.empty?
            a[k_name] = val.first
          end
          a
        end
      end

      def to_matrix_s
        @to_matrix_s ||= matrix_keys.map{|k,v| "#{k}:#{v}" }.sort.join(", ")
      end

      def to_script_builder(build)
        ScriptBuilder.new(build, self)
      end

      def env
        attributes["env"]
      end

      def matrix_env
        attributes["env"]["matrix"]
      end

      def global_env
        attributes["env"]["global"]
      end

      def cached_directories
        if attributes["cache"] == false
          false
        else
          (attributes["cache"] && attributes["cache"]["directories"]) || []
        end
      end

      AS_ARRAY.each do |m|
        define_method m do
          @attributes[m] || []
        end
      end

      def merge(attrs = {})
        self.class.from_attributes self.attributes.merge(attrs)
      end

      private

        def normalize_attributes(attributes)
          attributes = attributes.inject({}) do |a,row|
            k,v = row
            if AS_ARRAY.include?(k.to_s)
              v = Array(v)
            end
            a[k.to_s] = v
            a
          end
          normalize_env_attribute attributes
        end

        def normalize_env_attribute(attributes)
          env = (attributes['env'] || {}) .dup
          case env
          when Hash
            attributes["env"] = {
              "matrix" => Array(env['matrix']),
              "global" => Array(env['global'])
            }
          else
            attributes['env'] = {
              "matrix" => Array(env).map(&:to_s),
              "global" => []
            }
          end
          freeze_normalized_attributes attributes
        end

        def freeze_normalized_attributes(attributes)
          attributes.freeze
          attributes['env'].freeze
          attributes['env']['global'].freeze
          attributes['env']['matrix'].freeze
          attributes
        end

    end
  end
end
