module DeepStore
  module Model
    module Attributes
      def self.included(base)
        base.class_eval do
          def initialize(params = {})
            params.each { |k, v| send("#{k}=", v) }
          end

          def attributes
            Hash[__schema__.keys.map { |k| [k, send(k)] }]
          end
        end
      end
    end
  end
end
