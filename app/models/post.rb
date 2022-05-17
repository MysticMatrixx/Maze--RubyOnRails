class Post < ApplicationRecord
  include Visible

  # def liked?(user)
  #   !!self.likes.find{|like| like.user_id == user.id }
  # end

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  validates :description, presence: true, length: { minimum: 5 }

  def self.description_comments_likes
    CSV.generate(headers: true) do |csv|
      csv << %w[description comments likes]

      all.each do |post|
        csv << [post.description, post.comments.count, post.likes.count]
      end
    end
  end

end
