xml.rss('version' => '2.0', 'xmlns:dc' => "http://purl.org/dc/elements/1.1/", 'xmlns:atom' => "http://www.w3.org/2005/Atom") do
  xml.channel do
    xml.title       @feed[:title]
    xml.link        "http://audiovision.scpr.org"
    xml.atom :link, href: @feed[:href], rel: "self", type: "application/rss+xml"
    xml.description @feed[:description]

    cache @posts do
      @posts.each do |post|
        xml.item do
          xml.title post.title
          xml.guid  post.public_url
          xml.link  post.public_url
          xml.dc :creator, post.byline

          if post.asset.present?
            xml.enclosure url: post.asset.full.url, type: "image/jpeg", length: post.asset.image_file_size.to_i
          end

          xml.description post.body.html_safe
          xml.pubDate post.published_at.rfc822
        end
      end
    end
  end
end
