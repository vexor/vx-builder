module Vx
  module Builder
    class Task

      attr_reader :name, :src, :sha, :deploy_key, :branch, :pull_request_id

      def initialize(name, src, sha, options = {})
        @name            = name
        @src             = src
        @sha             = sha
        @deploy_key      = options[:deploy_key]
        @branch          = options[:branch]
        @pull_request_id = options[:pull_request_id]

        validate!
      end

      private

        def validate!
          (name && src && sha && deploy_key && branch) or
            raise(MissingKeys)
        end

    end
  end
end
