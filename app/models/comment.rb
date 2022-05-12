class Comment < ApplicationRecord
  validates :content, presence: true
  # named_scope :for_user, lambda{ |user| {:conditions=>{:user_id => user.id}}}

  belongs_to :post
  belongs_to :user
  has_many :likes, as: :likeable, dependent: :destroy
end
