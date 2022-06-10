class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  after_create :assign_default_role

  validates :phone, presence: true,
                    uniqueness: true,
                    length: { minimum: 10, maximum: 10 },
                    numericality: { only_integer: true }
  # { case_sensitive: false }

  # has_one_attached :file_csv
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy


  def active_for_authentication?
    super and is_active?
  end

  def inactive_message
    is_active? ? super : 'Deactivated Account!'
  end

  # private

  def assign_default_role
    add_role(:user) if roles.blank?
  end

  def self.import(row)
    accessible_attributes = %w[first_name last_name id password email phone]
    # CSV.foreach(file, headers: true) do |row|
    user = find_by_id(row['id']) || new
    user.attributes = row.slice(*accessible_attributes)
    user.skip_confirmation!
    user.save!
    user.add_role :user
    # User.create! row.to_hash
  end

  # Generate a CSV File of All User Records:

  def self.name_posts_comments_likes
    CSV.generate(headers: true) do |csv|
      csv << %w[id name posts comments likes]

      all.each do |user|
        csv << [user.id, "#{user.first_name} #{user.last_name}",
                user.posts.count, user.comments.count, user.likes.count]
      end
    end
  end

  def self.up10_name_posts_comments_likes
    CSV.generate(headers: true) do |csv|
      csv << %w[id name posts comments likes]

      all.each do |user|
        if user.posts.count >= 10
          csv << [user.id, "#{user.first_name} #{user.last_name}",
                  user.posts.count, user.comments.count, user.likes.count]
        end
      end
    end
  end

  # def name
  #   "#{first_name} #{last_name}"
  # end
  #
  # def self.to_csv
  #   attributes = %w[id email name]
  #
  #   CSV.generate(headers: true) do |csv|
  #     csv << attributes
  #
  #     all.each do |user|
  #       csv << attributes.map{ |attr| user.send(attr) }
  #     end
  #   end
  # end
  #
  #
  # enum role: %i[user admin]
  # after_initialize :set_default_role, if: :new_record?
  # def set_default_role
  #   self.role ||= :user
  # end
end
