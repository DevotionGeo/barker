class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :sent_messages, class_name: Message, foreign_key: "author_id"
  has_many :received_messages, class_name: Message, foreign_key: "receiver_id"
  has_many :relationships
  has_many :friends, through: :relationships, class: User
  validates :profile_name, uniqueness: true
  validates :first_name, :last_name, :profile_name, presence: true, length: { minimum: 2 }
  before_save :capitalize_name

  def self.search(search)
    where("(lower(last_name) || lower(first_name) || lower(profile_name)) LIKE ?", "%#{search.downcase}%")
  end

  def is_allowed_to_see_profile(friend)
    !friend.nil? && (friend.id == id || Relationship.friends?(self, friend))
  end

  private
  def capitalize_name
    self.first_name.capitalize!
    self.last_name.capitalize!
  end
end
