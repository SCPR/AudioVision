module AdminListHelper
  STATUS_BOOTSTRAP_MAP = {
    Post::STATUS[:killed]       => "list-status label label-important",
    Post::STATUS[:draft]        => "list-status label",
    Post::STATUS[:pending]      => "list-status label label-warning",
    Post::STATUS[:published]    => "list-status label label-success"
  }

  def display_status(status)
    content_tag :div, Post::STATUS_TEXT[status], class: STATUS_BOOTSTRAP_MAP[status]
  end
  

  def status_bootstrap_map
  end
end
