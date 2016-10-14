# DeepStore

DeepStore is a ODM-like solution to manage S3-backed data. It provides a familiar interface to perform basic operations on files stored in S3 and facilitates their manipulation by abstracting away its intricacies. It's an opinionated but extensible library that follows "convention over configuration" and attempts to maximize developer productivity at the expense of deeper control.

## WARNING
This is a **Beta** version. It works, but please keep that in mind and feel free to communicate any issues, suggestions or PRs ;-)

# Configuration

```
# /config/initializers/dd.rb
DeepStore.configure do |c|
  c.bucket = bucket # defaults to ENV['DEEP_DIVE_BUCKET']
  c.access_key_id = access_key_id # defaults to ENV['AWS_ACCESS_KEY_ID']
  c.secret_access_key = secret_access_key # defaults to ENV['AWS_SECRET_ACCESS_KEY']
  c.region = region # defaults to 'us-east-1' and fallback to ENV['AWS_REGION']
end
```

# How to Use

```ruby
class Log
  include DeepStore::Model

  bucket 'awesome-bucket' # defaults to DeepStore.settings.bucket
  key ':dataset/:year/:month/:day/:hour/:minute/:filename'
  codec :gzip # defaults to :null

  attr_accessor :year, :month, :day, :hour, :minute

  attribute :dataset
  attribute :timestamp
  attribute :filename

  validates :dataset,   presence: true
  validates :timestamp, presence: true
  validates :filename,  presence: true

  # Necessary for object instantiation from a provided key
  def timestamp
    @timestamp ||= Time.new(year, month, day, hour, minute, '+00:00')
  end

  def year
    timestamp.strftime('%Y')
  end

  def month
    timestamp.strftime('%m')
  end

  def day
    timestamp.strftime('%d')
  end

  def hour
    timestamp.strftime('%H')
  end

  def minute
    timestamp.strftime('%M')
  end
end

log = Log.find('events/3/2016/10/10/00/00/log-1234.gz')

# Most codecs should provide a standard IO-like interface
while (chunk = log.read(8 * 1024))
  puts chunk
end

log.rewind

log.each do |line|
  JSON.parse(line)
end

log.write('SOME BOGUS DATA')

log.save
```
