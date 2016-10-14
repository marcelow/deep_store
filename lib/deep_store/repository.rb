module DeepStore
  class Repository
    extend Forwardable

    attr_accessor :adapter
    attr_reader :bucket, :codec, :resource_class, :dao

    def_delegators :dao, :head, :get, :put, :delete

    def initialize(data = {})
      @data           = data
      @adapter        = data.fetch(:adapter, DeepStore.adapter)
      @bucket         = data.fetch(:bucket, DeepStore.settings.bucket)
      @codec          = data.fetch(:codec)
      @resource_class = data.fetch(:resource_class)
      @dao            = DAO.new(adapter: @adapter, bucket: @bucket, codec: @codec)
    end

    def find(key)
      Operations::FindQuery.new(dao, resource_class, key: key).result
    end

    def where(query = {})
      Operations::WhereQuery.new(dao, resource_class, query: query).result
    end

    def save(resource)
      Operations::SaveOperation.new(dao, resource_class, resource: resource).result
    end

    def destroy(key)
      Operations::DestroyOperation.new(dao, resource_class, key: key).result
    end
  end
end
