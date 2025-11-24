class Song < ApplicationRecord
  belongs_to :user
  belongs_to :artist  
  
  validates :title, :year, presence: true
  validates :artist_id, presence: true  

  scope :public_songs, -> {where(is_public: true)}

end