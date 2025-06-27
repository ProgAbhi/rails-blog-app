class BlogTag < ApplicationRecord
  belongs_to :blog
  belongs_to :tag
  
  accepts_nested_attributes_for :tag
  validates :rank, numericality: { only_integer: true }, allow_nil: true
end