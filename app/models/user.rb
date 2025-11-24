class User < ApplicationRecord
    has_secure_password
  
  has_many :songs, dependent: :destroy
  has_many :artists, dependent: :destroy
  
  validates :username, :email, presence: true, uniqueness: true
  validates :password, length: {minimum: 6}, allow_nil: true #allow nil for updates

  validates :artist_name, uniqueness: true, allow_nil: true
  
  def display_artist_name
    artist_name.presence || username
  end

  #email validation
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  scope :artist, -> { where(is_artist: true)}

end
