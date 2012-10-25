require 'sinatra'

get '/' do
  'Nothing to see here. Move along.'
end

get %r{/(\d+)} do |image_id|
  image_id
end
