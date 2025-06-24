class Blog < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  has_many :blog_tags, dependent: :destroy
  has_many :tags, through: :blog_tags

  # Virtual attribute for tag input (e.g., "travel, ruby, tech")
  def tag_list
    tags.pluck(:name).join(', ')
  end

  def tag_list=(names)
    self.tags = names.split(',').map(&:strip).reject(&:blank?).uniq.map do |tag_name|
      Tag.find_or_create_by(name: tag_name)
    end
  end
end
