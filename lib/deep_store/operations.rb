module DeepStore
  module Operations
    autoload :Operation,        File.expand_path('../operations/operation', __FILE__)
    autoload :FindQuery,        File.expand_path('../operations/find_query', __FILE__)
    autoload :WhereQuery,       File.expand_path('../operations/where_query', __FILE__)
    autoload :SaveOperation,    File.expand_path('../operations/save_operation', __FILE__)
    autoload :DestroyOperation, File.expand_path('../operations/destroy_operation', __FILE__)
  end
end
