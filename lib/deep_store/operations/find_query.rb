module DeepStore
  module Operations
    class FindQuery
      include Operation

      def result
        return unless dao.head(data[:key])
        attributes         = KeyParser.call(data[:key], resource_class.settings[:key])
        resource           = resource_class.new(attributes)
        resource.persisted = true
        resource
      end
    end
  end
end
