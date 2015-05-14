class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :messages

  validates :profile_name, uniqueness: true
  validates :first_name, :last_name, :profile_name, presence: true, length: { minimum: 2 }
end
