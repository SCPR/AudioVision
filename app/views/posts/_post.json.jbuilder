json.id           post.id
json.title        post.title
json.subtitle     post.subtitle
json.published_at post.published_at
json.byline       post.byline
json.public_url   post.public_url
json.updated_at   post.updated_at
json.category     post.category.title
json.teaser       post.teaser.html_safe
json.body         post.body.html_safe

asset = post.assets.first
json.thumbnail asset ? asset.lsquare.tag : nil
