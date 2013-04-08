module ApplicationHelper
  def nav_link(*args)
    options   = args.extract_options!
    key       = options.delete(:key)

    content_tag :li, link_to(*args), class: ("selected" if @nav_highlight == key)
  end
end
