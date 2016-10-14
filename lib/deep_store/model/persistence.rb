module DeepStore
  module Model
    module Persistence
      def self.included(base)
        base.extend(ClassMethods)

        base.class_eval do
          attr_accessor :persisted

          def persisted?
            return(@persisted) if defined?(@persisted)
            @persisted = false
          end

          def save
            return unless __repository__.save(self)
            @persisted = true
          end

          def destroy
            __repository__.destroy(key)
            @persisted = true
          end

          def key
            KeyFactory.call(self, __settings__.fetch(:key))
          end
        end
      end

      module ClassMethods
        def create(data = {})
          new(data).save
        end

        def destroy(key)
          repository.destroy(key)
        end

        def repository
          @repository ||= Repository.new(bucket:         settings[:bucket],
                                         codec:          settings[:codec],
                                         resource_class: self)
        end
      end
    end
  end
end
