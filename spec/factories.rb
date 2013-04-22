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
  end

  factory :user do
  end
end
