FactoryGirl.define do
  factory :post do
    title "Post about something"
    subtitle "It's interesting I swear"
    status 5
    sequence(:published_at) { |n| Time.now + n.days }
    body "This is a post about something."
    teaser "Teaser"
    post_type 0
    category
  end

  #---------------

  factory :billboard do
    layout 1
    status 5
    sequence(:published_at) { |n| Time.now + n.days }
  end

  #---------------

  factory :attribution do
    role 1

    trait :with_post do
      post
    end

    trait :with_reporter do
      reporter
    end

    trait :without_reporter do
      name "Phillip J. Fry"
      url "http://marsuniversity.edu"
    end
  end

  #---------------

  factory :post_asset do
    post
    asset_id 999
    sequence(:position)
  end

  #---------------

  factory :bucket do
    title "Instant Grams"
    sequence(:key) { |n| "instant-grams#{n}" }
    description "All the instant-grams you can handle."
  end

  #---------------

  factory :category do
    title "Images"
    slug { title.parameterize }
    description "These are some images"
  end

  #---------------
  # Need to pass in referrer
  factory :post_reference do
    post
    sequence(:position)
  end

  #---------------

  factory :publish_alarm do
  end

  #---------------

  factory :reporter do
    name "Hermes Conrad"
    bio "Hermes likes to relax the traditional Jamaican way: A warm glass of milk and a good night's sleep."
    slug { name.parameterize }
    asset_id 999
    twitter_handle "hconrad"
    email "hconrd@planetexpress.com"
  end

  #---------------

  factory :user do
    name "Scruffy"
    sequence(:username) { |n| "scruffy#{n}" }
    email "scruffy@planetexpress.com"
    can_login true
    is_superuser false

    password "secret"
    password_confirmation "secret"
  end
end
