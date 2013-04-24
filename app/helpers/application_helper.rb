module ApplicationHelper
  def nav_link(*args)
    options   = args.extract_options!
    key       = options.delete(:key)

    content_tag :li, link_to(*args), class: ("selected" if @nav_highlight == key)
  end

  #---------------

  def render_byline(post)
    render "shared/byline", 
      elements: byline_elements(post.attributions.for_byline)
  end

  #---------------
  # This is broken into a separate method so that 
  # the Contributors list can use the logic as well.
  #
  # Take an array of attributions (a single attribution
  # works too) and return an array of rendered attributions. 
  # All you have to do is iterate through them and print 
  # them once you have this array.
  def byline_elements(attributions)
    elements = []

    Array(attributions).each do |attribution|
      if attribution.display_name.present?
        if attribution.display_url.present?
          elements << link_to(attribution.display_name, attribution.display_url)
        else
          elements << attribution.display_name
        end
      end
    end

    elements
  end


  #---------------
  # These two methods are taken from EscapeUtils
  def html_escape(string)
    EscapeUtils.escape_html(string.to_s).html_safe
  end
  alias_method :h, :html_escape

  def url_encode(s)
    EscapeUtils.escape_url(s.to_s).html_safe
  end
  alias_method :u, :url_encode


  #---------------

  def meta_information
    @meta_hash ||= {}
  end

  def meta_tags(hash)
    meta_information.merge!(hash)
  end
end
