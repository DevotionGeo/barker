class Relationship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class: User
  validates :user, :friend, presence: true
  validates :accepted, inclusion: { in: [true, false] }

  def self.friends?(u, f)
    !Relationship.where(user: u, friend: f, accepted: true).empty? || !Relationship.where(user: f, friend: u, accepted: true).empty?
  end
end
