json.cache! post do
  json.id post.obj_key
  json.title post.to_title
  json.byline post.byline
  json.published_at post.published_at
  json.teaser post.teaser.html_safe
  json.body post.body.html_safe
  json.permalink post.remote_link_path

  asset = post.assets.first
  json.thumbnail asset ? post.asset.lsquare.tag : nil


  if post.category.present?
    json.category do
      json.id post.category.id
      json.title post.category.title
      json.slug post.category.slug
      json.description post.category.description
      json.permalink post.category.remote_link_path
    end
  end


  json.assets post.assets do |asset|
    json.title asset.title
    json.caption asset.caption.present? ? asset.caption : asset.asset.caption
    json.owner asset.owner

    json.thumbnail do
      json.url asset.lsquare.url
      json.width asset.lsquare.width
      json.height asset.lsquare.height
    end

    json.small do
      json.url asset.small.url
      json.width asset.small.width
      json.height asset.small.height
    end

    json.large do
      json.url asset.eight.url
      json.width asset.eight.width
      json.height asset.eight.height
    end

    json.full do
      json.url asset.full.url
      json.width asset.full.width
      json.height asset.full.height
    end
  end


  json.attributions post.attributions do |attribution|
    json.name attribution.display_name
    json.url attribution.display_url

    json.role_text attribution.role_text 
    json.role attribution.role
  end
end
