module ApplicationHelper
  def nav_link(*args)
    options   = args.extract_options!
    key       = options.delete(:key)

    content_tag :li, link_to(*args), class: ("selected" if @nav_highlight == key)
  end


  def render_byline(post)
    attributions = post.attributions.for_byline
    byline_elements = []

    attributions.each do |attribution|
      if (reporter = attribution.reporter)
        byline_elements << link_to(reporter.name, reporter.link_path)

      elsif attribution.name.present?
        if attribution.url.present?
          byline_elements << link_to(attribution.name, attribution.url)
        else
          byline_elements << attribution.name
        end
      end
    end

    render "shared/byline", elements: byline_elements
  end

  # These two methods are taken from EscapeUtils
  def html_escape(string)
    EscapeUtils.escape_html(string.to_s).html_safe
  end
  alias_method :h, :html_escape

  def url_encode(s)
    EscapeUtils.escape_url(s.to_s).html_safe
  end
  alias_method :u, :url_encode


  def meta_information
    @meta_hash ||= {}
  end

  def meta_tags(hash)
    meta_information.merge!(hash)
  end
end
