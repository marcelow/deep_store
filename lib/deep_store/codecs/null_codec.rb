module DeepStore
  module Codecs
    class NullCodec
      include Codec

      def encode(stream)
        stream
      end

      def decode(stream)
        stream
      end
    end
  end
end
