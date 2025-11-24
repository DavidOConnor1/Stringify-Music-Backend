class User < ApplicationRecord
    has_secure_password
  
  has_many :songs, dependent: :destroy
  has_many :artists, dependent: :destroy
  
  validates :username, :email, presence: true, uniqueness: true
  validates :password, length: {minimum: 6}, allow_nil: true #allow nil for updates

  #email validation
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  scope :artist, -> { where(is_artist: true)}

end
