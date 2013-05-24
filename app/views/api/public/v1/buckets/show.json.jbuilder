json.cache! [Api::Public::V1::VERSION, @bucket] do
  json.partial! @bucket

  json.posts @bucket.posts do |post|
    json.partial! 'api/public/v1/posts/post', post: post
  end
end
