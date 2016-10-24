module DeepStore
  class Sweeper
    attr_reader :stream

    def self.register(object, stream)
      sweeper = Sweeper.new(stream)
      ObjectSpace.define_finalizer(object, sweeper)
      sweeper
    end

    def initialize(stream)
      @stream = stream
    end

    def call(_object_id)
      finalize
    end

    def finalize
      stream.close if stream.respond_to?(:close)
      stream.unlink if stream.respond_to?(:unlink)
    end
  end
end
