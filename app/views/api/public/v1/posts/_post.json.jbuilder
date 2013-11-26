json.cache! [Api::Public::V1::VERSION, post] do
  json.id           post.obj_key
  json.title        post.to_title
  json.subtitle     post.subtitle
  json.byline       post.byline
  json.published_at post.published_at
  json.teaser       post.teaser.html_safe
  json.body         post.body.html_safe
  json.public_url   post.public_url

  asset = post.assets.first
  json.thumbnail asset ? asset.lsquare.tag : nil


  if post.category.present?
    json.category do
      json.id          post.category.id
      json.title       post.category.title
      json.slug        post.category.slug
      json.description post.category.description
      json.public_url  post.category.public_url

      json.permalink   post.category.public_url # Deprecated
    end
  end


  json.assets post.assets do |asset|
    json.title    asset.title
    json.caption  asset.caption.present? ? asset.caption : asset.asset.caption
    json.owner    asset.owner

    if asset.native.present?
      json.native do
        json.type asset.native["class"]
        json.id   asset.native["videoid"]
      end
    end

    json.thumbnail do
      json.url    asset.lsquare.url
      json.width  asset.lsquare.width
      json.height asset.lsquare.height
    end

    json.small do
      json.url    asset.small.url
      json.width  asset.small.width
      json.height asset.small.height
    end

    json.large do
      json.url    asset.eight.url
      json.width  asset.eight.width
      json.height asset.eight.height
    end

    json.full do
      json.url    asset.full.url
      json.width  asset.full.width
      json.height asset.full.height
    end
  end


  json.attributions post.attributions do |attribution|
    json.name       attribution.display_name
    json.url        attribution.display_url
    json.role_text  attribution.role_text
    json.role       attribution.role
  end

  json.permalink    post.public_url # Deprecated
end
