json.partial! @bucket

json.posts @bucket.posts do |post|
  json.partial! 'api/public/v1/posts/post', post: post
end
