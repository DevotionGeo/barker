class Message < ActiveRecord::Base
  belongs_to :author, class: User
  belongs_to :receiver, class: User

  validates :content, :author, :receiver, presence: true
end
