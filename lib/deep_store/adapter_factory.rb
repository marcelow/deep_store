module DeepStore
  class AdapterFactory
    def self.call(*args)
      new.call(*args)
    end

    def call(settings)
      credentials = Aws::Credentials.new(settings.access_key_id, settings.secret_access_key)

      Aws::S3::Client.new(region: settings.region, credentials: credentials)
    end
  end
end
