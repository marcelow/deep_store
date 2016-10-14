module DeepStore
  module Operations
    class DestroyOperation
      include Operation

      def result
        dao.delete(data[:key])
        true
      end
    end
  end
end
