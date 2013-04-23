FactoryGirl.define do
  factory :post do
    title "Post about something"
    subtitle "It's interesting I swear"
    status 5
    body "This is a post about something."
    teaser "Teaser"
    media_type 0
    category
  end

  factory :billboard do
  end

  factory :attribution do
    post
    role 1

    trait :with_reporter do
      reporter
    end

    trait :without_reporter do
      name "Phillip J. Fry"
      url "http://marsuniversity.edu"
    end
  end

  factory :post_asset do
  end

  factory :bucket do
  end

  factory :category do
    title "Images"
    slug "images"
    description "These are some images"
  end

  factory :post_reference do
  end

  factory :publish_alarm do
  end

  factory :reporter do
    user
    name "Hermes Conrad"
    bio "Hermes likes to relax the traditional Jamaican way: A warm glass of milk and a good night's sleep."
    slug { name.parameterize }
    asset_id 999
    twitter_handle "hconrad"
    email "hconrd@planetexpress.com"
  end

  factory :user do
    name "Scruffy"
    username "scruffy"
    email "scruffy@planetexpress.com"
    can_login true
    is_superuser false
    
    password "secret"
    password_confirmation "secret"
  end
end
