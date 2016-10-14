module DeepStore
  class DAO
    attr_reader :adapter, :bucket, :codec, :resource_class

    Result = Class.new(OpenStruct)

    def initialize(data = {})
      @adapter = data.fetch(:adapter, DeepStore.adapter)
      @bucket  = data.fetch(:bucket, DeepStore.settings.bucket)
      @codec   = data.fetch(:codec)
    end

    def head(key)
      adapter.head_object(bucket: bucket, key: key)
    rescue Aws::S3::Errors::NoSuchKey
      raise DeepStore::Errors::RecordNotFound
    end

    def get(key)
      stream = Tempfile.new
      object = adapter.get_object(bucket: bucket, key: key, response_target: stream)
      Result.new(object: object, stream: codec.decode(stream))
    rescue Aws::S3::Errors::NoSuchKey
      raise DeepStore::Errors::RecordNotFound
    end

    def put(key, stream)
      encoded_stream = codec.encode(stream)
      adapter.put_object(bucket: bucket, key: key, body: encoded_stream)
    end

    def delete(key)
      adapter.delete_object(bucket: bucket, key: key)
    end

    def expand_path(path)
      keys   = []
      marker = nil

      while (objects = remote_objects_for(path, marker)).any?
        keys.concat(objects.map(&:key))
        marker = objects.last.key
      end

      keys.uniq
    end

    private

    def remote_objects_for(path, marker = nil)
      adapter.list_objects(bucket: bucket, prefix: path, marker: marker, max_keys: 50).contents
    end
  end
end
