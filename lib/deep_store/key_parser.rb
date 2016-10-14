module DeepStore
  class KeyParser
    def self.call(*args)
      new.call(*args)
    end

    def call(key, pattern)
      dimensions = pattern.scan(/\:(\w+)/).flatten.map(&:to_sym)
      parser     = pattern.gsub(/\:(\w+)/) { |m| '(?<' + m[1..-1] + '>[a-zA-Z0-9\-_.]+)' }
      match      = key.match(parser)
      return {} unless match

      Hash[dimensions.zip(match.to_a[1..-1])]
    end
  end
end
