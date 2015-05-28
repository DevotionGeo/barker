class Message < ActiveRecord::Base
  belongs_to :author, class: User
  belongs_to :receiver, class: User

  validates :content, :author, :receiver, presence: true
  before_save :author_and_receiver_are_friends_or_same_person

  private
  def author_and_receiver_are_friends_or_same_person
    if author_id == receiver_id
      true
    elsif !Relationship.friends?(User.find(author_id), User.find(receiver_id))
      errors.add(:base, "Author and receiver of the message must be friends or the same person")
      false
    end
  end
end
