json.partial! @billboard

json.posts @billboard.posts do |post|
  json.partial! 'api/public/v1/posts/post', post: post
end
