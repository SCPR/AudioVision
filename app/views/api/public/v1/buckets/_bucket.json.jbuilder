json.id @bucket.key
json.title @bucket.title
json.description @bucket.description
json.updated_at @bucket.updated_at

json.posts @bucket.posts do |post|
  json.partial! 'api/public/v1/posts/post', post: post
end
