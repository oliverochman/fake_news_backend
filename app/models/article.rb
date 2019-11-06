class Article < ApplicationRecord
  validates :title, presence: true, length: { minimum: 3, maximum: 50 }
  validates :content, presence: true, length: { minimum: 10, maximum: 250 }
  has_one_attached :image
  has_one :category
  belongs_to :journalist, class_name: 'User'
end
