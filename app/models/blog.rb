class Blog < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  has_many :blog_tags, dependent: :destroy
  has_many :tags, through: :blog_tags

  accepts_nested_attributes_for :blog_tags, allow_destroy: true, reject_if: ->(attrs) {
    attrs['tag_attributes'].blank? || attrs['tag_attributes']['name'].blank?
  }
end
