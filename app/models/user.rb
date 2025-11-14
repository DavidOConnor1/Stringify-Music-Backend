class User < ApplicationRecord
    has_secure_password
  
  has_many :songs, dependent: :destroy
  has_many :artists, dependent: :destroy
  
  validates :username, :email, presence: true, uniqueness: true
end
