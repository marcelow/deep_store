require 'deep_store/version'
require 'forwardable'
require 'ostruct'
require 'aws-sdk'
require 'active_model'
require 'mime/types'
require 'fileutils'

module DeepStore
  autoload :Settings,       'deep_store/settings'
  autoload :AdapterFactory, 'deep_store/adapter_factory'
  autoload :DAO,            'deep_store/dao'
  autoload :Repository,     'deep_store/repository'
  autoload :CodecFactory,   'deep_store/codec_factory'
  autoload :Model,          'deep_store/model'
  autoload :Query,          'deep_store/query'
  autoload :Codecs,         'deep_store/codecs'
  autoload :Operations,     'deep_store/operations'
  autoload :KeyParser,      'deep_store/key_parser'
  autoload :Sweeper,        'deep_store/sweeper'
  autoload :Errors,         'deep_store/errors'

  def self.adapter
    @adapter ||= AdapterFactory.call(settings)
  end

  def self.configure(&block)
    block.call(settings)
  end

  def self.settings
    @settings ||= Settings.new(bucket:            ENV['DEEP_DIVE_BUCKET'],
                               region:            ENV.fetch('AWS_REGION', 'us-east-1'),
                               access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
                               secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])
  end
end
