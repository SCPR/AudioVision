module ApplicationHelper
  def nav_link(*args)
    options   = args.extract_options!
    key       = options.delete(:key)

    content_tag :li, link_to(*args), class: ("selected" if @nav_highlight == key)
  end


  def render_byline(post)
    attributions = post.attributions.where('role in (?)', [Attribution::ROLE_AUTHOR, Attribution::ROLE_SOURCE]).order('role')
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

    byline_elements.join(" / ").html_safe
  end
end
