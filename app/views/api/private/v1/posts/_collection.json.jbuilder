json.array! posts do |post|
  json.partial! "api/private/v1/posts/post", post: post
end
