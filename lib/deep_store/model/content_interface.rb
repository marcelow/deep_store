module DeepStore
  module Model
    module ContentInterface
      def self.included(base)
        base.class_eval do
          extend Forwardable

          attr_reader :sweeper

          def_delegators :content, :read, :write, :rewind, :each, :puts, :close, :unlink

          def reload
            @content = nil
          end

          def content
            return @content if @content
            self.content = persisted? ? __repository__.get(key).stream : Tempfile.new
          end

          def content=(stream)
            @content = stream
            @sweeper = Sweeper.register(self, stream)
          end

          def finalize
            sweeper&.finalize
          end
        end
      end
    end
  end
end
