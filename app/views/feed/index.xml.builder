xml.rss('version' => '2.0', 'xmlns:dc' => "http://purl.org/dc/elements/1.1/", 'xmlns:atom' => "http://www.w3.org/2005/Atom") do
  xml.channel do
    xml.title       "#{@feed[:title]} | AudioVision | KPCC"
    xml.link        "http://audiovision.scpr.org"
    xml.atom :link, href: @feed[:href], rel: "self", type: "application/rss+xml"
    xml.description @feed[:description]
    
    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.guid  post.remote_link_path
        xml.link  post.remote_link_path
        xml.dc :creator, post.byline

        if post.assets.first.present?
          asset = post.assets.first.asset
          xml.enclosure url: asset.thumb.url, type: "image/jpeg", length: asset.image_file_size.to_i / 100
        end

        xml.description post.body.html_safe
        xml.pubDate post.published_at.rfc822
      end
    end
  end
end
