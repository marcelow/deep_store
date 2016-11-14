require 'zlib'

module DeepStore
  module Codecs
    class GzipCodec
      include Codec

      CHUNK_SIZE = 1024 * 1024

      def decode(stream)
        decompressed_stream = Tempfile.new
        decompressed_stream.binmode

        Zlib::GzipReader.open(stream) do |gz|
          while (chunk = gz.read(CHUNK_SIZE))
            decompressed_stream.write(chunk)
          end
        end

        stream.rewind
        decompressed_stream.rewind
        decompressed_stream
      end

      def encode(stream)
        compressed_stream = Tempfile.new
        compressed_stream.binmode

        Zlib::GzipWriter.open(compressed_stream.path) do |gz|
          while (chunk = stream.read(CHUNK_SIZE))
            gz.write(chunk)
          end
        end

        stream.rewind
        compressed_stream.rewind
        compressed_stream
      end
    end
  end
end
