module DeepStore
  module Model
    autoload :Persistence, File.expand_path('../model/persistence', __FILE__)
    autoload :KeyFactory, File.expand_path('../model/key_factory', __FILE__)
    autoload :ContentInterface, File.expand_path('../model/content_interface', __FILE__)
    autoload :DSL, File.expand_path('../model/dsl', __FILE__)
    autoload :Attributes, File.expand_path('../model/attributes', __FILE__)

    def self.included(base)
      base.extend(ClassMethods)

      base.class_eval do
        extend DeepStore::Model::DSL
        include ActiveModel::Serialization
        include ActiveModel::Validations
        include Persistence
        include ContentInterface
        include Attributes

        private

        def __repository__
          self.class.repository
        end

        def __schema__
          self.class.schema
        end

        def __settings__
          self.class.settings
        end
      end
    end

    module ClassMethods
      extend Forwardable

      def_delegators :repository, :find, :where, :destroy
    end
  end
end
