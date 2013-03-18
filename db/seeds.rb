# Creates a user to use with a brand new app. 
# This user should be deleted.
User.create!(
  :name           => "DETELE ME!",
  :email          => "admin@scpr.org",
  :is_superuser   => true,
  :can_login      => true,
  :password       => "super.secret!"
)
