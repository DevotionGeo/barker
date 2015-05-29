class Relationship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class: User
  validates :user, :friend, presence: true
  validates :accepted, inclusion: { in: [true, false] }
  validates :user_id, :uniqueness => {:scope => [:friend_id]}

  def self.friends?(u, f)
    relationship?(u, f, true)
  end

  def self.pending_friends?(u, f)
    relationship?(u, f, false)
  end

  private
  def self.relationship?(u, f, a)
    !Relationship.where(user: u, friend: f, accepted: a).empty? ||
    !Relationship.where(user: f, friend: u, accepted: a).empty?
  end
end
