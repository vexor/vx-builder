module Vx
  module Builder
    class Source
      class Matrix

        KEYS = (Source::LANGS + %w{ gemfile matrix_env:env image }).freeze
        NOT_MATRIX_KEYS = %w{
          script before_script services before_install
          after_success
        }

        attr_reader :source

        def initialize(build_configuration)
          @source = build_configuration
        end

        def keys
          extract_pair_of_key_and_values.map(&:first).sort
        end

        def configurations
          attributes_for_new_configurations_with_merged_env.map do |attrs|
            attrs = attrs.merge(
              NOT_MATRIX_KEYS.inject({}) do |a,v|
                a[v] = source.public_send(v)
                a
              end
            )
            Source.new attrs
          end
        end

        def attributes_for_new_configurations_with_merged_env
          attrs = attributes_for_new_configurations
          attrs = [{}] if attrs.empty?
          attrs.map do |a|
            e = a["env"]
            a["env"] = {
              "global" => Array(e) + source.global_env,
              "matrix" => e
            }
            a
          end
          attrs
        end

        def attributes_for_new_configurations
          permutate_and_build_values.inject([]) do |ac, values|
            ac << values.inject({}) do |a,val|
              a[val.key] = val.value
              a
            end
            ac
          end
        end

        def permutate_and_build_values
          values = extract_pair_of_key_and_values.map do |key, vals|
            vals.map{|it| Value.new(key, it) }
          end
          if matrix_values?(values)
            array_permutations(values).map do |it|
              if it.is_a?(Array)
                it.flatten
              else
                [it]
              end
            end
          else
            [values.flatten]
          end.sort_by(&:to_s)
        end

        def extract_pair_of_key_and_values
          KEYS.map.inject([]) do |a, k|
            k_method, k_name = k.split(":")
            k_name ||= k_method

            if (val = source[k_method]) && !val.empty?
              a << [k_name, val]
            end
            a
          end
        end

        private

          def matrix_values?(values)
            !values.all?{|i| i.size == 1 }
          end

          def array_permutations array, index=0
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

          Value = Struct.new(:key, :value) do
            def to_s
              [key, value].join(":")
            end
          end

      end
    end
  end
end
