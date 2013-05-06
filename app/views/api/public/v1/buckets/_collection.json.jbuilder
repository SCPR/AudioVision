json.array! buckets do |bucket|
  json.partial! "api/public/v1/buckets/bucket", bucket: bucket
end
