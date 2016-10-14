module DeepStore
  module Codecs
    module Codec
      def self.included(base)
        base.class_eval do
          def initialize(options = {})
            @options = options
          end

          def decode(_)
            raise NotImplementedError
          end

          def encode(_)
            raise NotImplementedError
          end

          private

          attr_reader :options
        end
      end
    end
  end
end
