module Vx
  module Builder
    Matrix = Struct.new(:build_configuration) do

      KEYS = %w{
        rvm
        gemfile
        scala
        jdk

        image
        env_matrix:env
      }

      def keys
        extract_keys_from_builds_configuration.map(&:first).sort
      end

      def build_configurations
        new_attributes = build_configuration.to_hash.dup
        attributes_for_new_build_configurations_with_merged_env.map do |matrix_attributes|
          new_attributes.merge!(matrix_attributes)
          BuildConfiguration.new new_attributes, matrix_attributes
        end
      end

      def deploy_configuration(branch)
        return unless build_configuration.deploy?

        availabled_providers = build_configuration.deploy.providers.select do |provider|
          provider.branch?(branch)
        end

        unless availabled_providers.empty?
          build_configurations.first.dup.tap do |config|
            config.deploy_attributes = availabled_providers.map(&:to_hash)
          end
        end
      end

      def attributes_for_new_build_configurations_with_merged_env
        attrs = attributes_for_new_build_configurations
        attrs = [{}] if attrs.empty?
        attrs.map! do |a|
          env = a["env"]
          a["env"] = {
            "global" => Array(env) + build_configuration.env.global,
            "matrix" => Array(env)
          }
          a
        end

        attrs
      end

      def attributes_for_new_build_configurations
        permutate_and_build_pairs.inject([]) do |ac, pairs|
          ac << pairs.inject({}) do |a,pair|
            a[pair.key] = pair.value
            a
          end
          ac
        end
      end

      def permutate_and_build_pairs
        pairs = extract_keys_from_builds_configuration.map do |key_name, values|
          values.map{|v| Pair.new(key_name, v) }
        end

        if not_matrix?(pairs)
          [pairs.flatten]
        else
          array_permutations(pairs).map do |it|
            if it.is_a?(Array)
              it.flatten
            else
              [it]
            end
          end
        end.sort_by(&:to_s)
      end

      def extract_keys_from_builds_configuration
        KEYS.inject([]) do |a, key|
          key_method, key_name = key.split(":")
          key_name ||= key_method

          value = build_configuration.public_send(key_method)
          unless value.empty?
            a << [key_name, value]
          end

          a
        end
      end

      private

        def not_matrix?(pairs)
          pairs.all?{|i| i.size == 1 }
        end

        def array_permutations(array, index=0)
          # index is 0 by default : start at the beginning, more elegant.
          return array[-1] if index == array.size - 1 # Return last element if at end.

          result = []

          array[index].each do |element| # For each array
            array_permutations(array, index + 1).each do |x| # Permute permute permute
              result << [element, x]
            end
          end
          result
        end

        Pair = Struct.new(:key, :value) do
          def to_s
            [key, value].join(":")
          end
        end

    end
  end
end
