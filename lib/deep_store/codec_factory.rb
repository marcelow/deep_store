module DeepStore
  class CodecFactory
    def self.call(*args)
      new.call(*args)
    end

    def call(codec_id, options = {})
      case codec_id
      when :gzip
        Codecs::GzipCodec.new(options)
      else
        Codecs::NullCodec.new(options)
      end
    end
  end
end
