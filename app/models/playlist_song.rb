class PlaylistSong < ApplicationRecord
  belongs_to :playlist
  belongs_to :song

  validates :playlist_id, presence: true
  validates :song_id, presence: true
  validates :position, presence: true, numericality: {only_integer: true, greater_than: 0}

  validates :song_id, uniquesness: {scope :playlist_id}

  before_validation :set_position, unless: :position?

  private

  def set_position
    max_position = PlaylistSong.where(playlist_id: playlist_id).maxium(:position) || 0
    self.position = max_position + 1
  end
end
