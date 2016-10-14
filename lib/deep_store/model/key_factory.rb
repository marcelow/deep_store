module DeepStore
  module Model
    class KeyFactory
      def self.call(*args)
        new.call(*args)
      end

      def call(resource, pattern)
        @resource = resource
        key = pattern.gsub(/\:(\w+)/) { |m| process_match(m) }
        key
      end

      private

      attr_reader :resource

      def process_match(match)
        attribute = match[1..-1]
        return unless resource.respond_to?(attribute)

        value = resource.send(attribute)
        return match unless value

        value
      end
    end
  end
end
