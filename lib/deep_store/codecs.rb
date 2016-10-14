module DeepStore
  module Codecs
    autoload :Codec, File.expand_path('../codecs/codec', __FILE__)
    autoload :NullCodec, File.expand_path('../codecs/null_codec', __FILE__)
    autoload :GzipCodec, File.expand_path('../codecs/gzip_codec', __FILE__)
  end
end
