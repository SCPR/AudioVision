module FlatpageHandler
  def handle_flatpage
    if @flatpage.redirect_to.present?
      redirect_to @flatpage.redirect_to and return
    end
    
    render template: 'flatpages/show'
  end
end
