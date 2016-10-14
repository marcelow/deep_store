module DeepStore
  module Model
    module ContentInterface
      def self.included(base)
        base.class_eval do
          extend Forwardable

          def_delegators :content, :read, :write, :rewind, :each, :puts, :close

          def reload
            @content = nil
          end

          def content
            return @content if @content
            self.content = persisted? ? __repository__.get(key).stream : Tempfile.new
          end

          def content=(stream)
            ObjectSpace.define_finalizer(self, -> { stream.close })
            @content = stream
          end
        end
      end
    end
  end
end
