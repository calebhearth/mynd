require 'imagemagic'
require 'redis'
require 's3'
require 'sinatra'

$redis = Redis.new
s3 = S3::Service.new(
  access_key_id: ENV['AMAZON_ACCESS_KEY_ID'],
  secret_access_key: ENV['AMAZON_SECRET_ACCESS_KEY'],
)

if $redis.get(:next_id)
  $redis.set(:next_id, 1)
end

get '/' do
  'Nothing to see here. Move along.'
end

post '/' do
  image = Image::Magic.from_blob(params['image'])
  next_id = $redis.get(:next_id)
  $redis.incr(:next_id)
  $redis.set(next_id, image.to_blob)
end

get %r{/(\d+)} do |image_id|
  $redis.get(image_id)
  s3
end
