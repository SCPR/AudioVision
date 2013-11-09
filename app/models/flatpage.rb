class Flatpage < ActiveRecord::Base
  outpost_model

  validates :path, {
    :presence => true,
    :format   => {
      :with => %r{\A\/[\w-]+\/\z},
      :message => "Letters, numbers, underscores, and hyphens only. Must begin and end with a slash."
    }
  }

  validates :title, presence: true
end
