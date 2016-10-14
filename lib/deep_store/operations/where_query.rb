module DeepStore
  module Operations
    class WhereQuery
      include Operation

      def result
        query = data[:query]

        dao.expand_path(query).map do |object|
          attributes         = KeyParser.call(object, resource_class.settings[:key])
          resource           = resource_class.new(attributes)
          resource.persisted = true
          resource
        end
      end
    end
  end
end
