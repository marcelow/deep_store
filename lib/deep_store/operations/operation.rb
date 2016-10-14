module DeepStore
  module Operations
    module Operation
      def self.included(base)
        base.class_eval do
          attr_reader :dao, :resource_class, :data, :options

          def initialize(dao, resource_class, data = {}, options = {})
            @dao            = dao
            @resource_class = resource_class
            @data           = data
            @options        = options
          end

          def result
            raise NotImplementedError
          end
        end
      end
    end
  end
end
