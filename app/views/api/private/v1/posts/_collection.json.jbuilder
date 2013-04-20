# This exists so that we can render this from another 
# controller without having to set @posts
json.array! posts do |post|
  json.partial! "api/private/v1/posts/post", post: post
end
