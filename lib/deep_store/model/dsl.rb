module DeepStore
  module Model
    module DSL
      def attribute(name, options = {})
        attr_accessor name
        schema[name] = options
      end

      def codec(codec_id, options = {})
        settings[:codec] = CodecFactory.call(codec_id, options: options)
      end

      def bucket(name)
        settings[:bucket] = name
      end

      def key(pattern)
        settings[:key] = pattern
      end

      def schema
        settings[:schema] ||= {}
      end

      def settings
        @settings ||= { codec: CodecFactory.call(id: :null, options: {}) }
      end
    end
  end
end
