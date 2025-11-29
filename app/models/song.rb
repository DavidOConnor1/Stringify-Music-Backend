class Song < ApplicationRecord
  belongs_to :user
  belongs_to :artist  
  
  has_many :playlist_songs, dependent: :destroy
  has_many :playlists, through: :playlist_songs

  validates :title, :year, presence: true
  validates :artist_id, presence: true  

  scope :public_songs, -> {where(is_public: true)}

end