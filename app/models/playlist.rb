class Playlist < ApplicationRecord
  belongs_to :user
  has_many :playlist_songs, dependent: :destroy
  has_many :songs, through: :playlist_songs

  validates :name, presence: true
  validates :user_id, presence: true

  scope :public_playlists, -> {where(is_public: true)}
  scope :by_user, ->(user_id) {where(user_id: user_id)}

  after_save :update_songs_count

  private

  def update_songs_count
    update_column(:songs_count, songs.count) if songs_count_changed?
  end
end
