module Vx
  module Builder
    MatrixBuilder = Struct.new(:build_configuration) do

      KEYS = %w{
        rvm
        gemfile
        scala
        jdk
        go
        node_js
        rust
        python
        php

        image
        env_matrix:env
      }

      def keys
        extract_keys_from_builds_configuration.map(&:first).sort
      end

      def build
        @build ||= begin
          if_empty do
            new_attributes = build_configuration.to_hash.dup
            build_configurations = attributes_for_new_build_configurations_with_parallel.map do |matrix_attributes|
              BuildConfiguration.new(
                new_attributes.merge(matrix_attributes),
                matrix_attributes
              )
            end
            filter_required_keys(
              filter_exclude(
                build_configuration.matrix.exclude,
                build_configurations
              )
            )
          end
        end
      end

      def attributes_for_new_build_configurations_with_parallel
        new_attrs = []
        attrs     = attributes_for_new_build_configurations_with_merged_env
        if build_configuration.parallel?
          attrs.each do |attr|
            1.upto(build_configuration.parallel) do |n|
              new_attrs << attr.merge("parallel_job_number" => n - 1)
            end
          end
          new_attrs
        else
          attrs
        end
      end

      def attributes_for_new_build_configurations_with_merged_env
        attrs = attributes_for_new_build_configurations
        attrs = [{}] if attrs.empty?
        attrs.map! do |a|
          env = a["env"]
          a["env"] = {
            "global" => build_configuration.env.global,
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

        def if_empty
          if build_configuration.empty?
            [build_configuration]
          else
            yield
          end
        end

        def filter_required_keys(configurations)
          configurations.select{|c| c.any? }
        end

        def filter_exclude(exclude, configurations)
          configurations.select do |c|
            !exclude.any? do |pair|
              pair.all? do |k,v|
                if k == 'env'
                  k = 'env_matrix'
                end

                c.respond_to?(k)              &&
                c.public_send(k).is_a?(Array) &&
                c.public_send(k).include?(v)
              end
            end
          end
        end

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
