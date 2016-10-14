module DeepStore
  module Operations
    class SaveOperation
      include Operation

      def result
        resource = data[:resource]
        return false unless resource.valid?

        resource.rewind
        dao.put(resource.key, resource.content)
        true
      end
    end
  end
end
