module AuthenticationHelper
  def login(options={})
    @user = create :user, options.reverse_merge!(username: "bricker", password: "secret")
    visit outpost.login_path
    fill_in "username", with: @user.username
    fill_in "password", with: "secret"
    click_button "Submit"
  end
end
