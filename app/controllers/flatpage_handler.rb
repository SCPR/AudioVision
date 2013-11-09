module FlatpageHandler
  def handle_flatpage
    @nav_highlight = @flatpage.path

    if @flatpage.redirect_to.present?
      redirect_to @flatpage.redirect_to and return
    end

    render template: 'flatpages/show'
  end
end
