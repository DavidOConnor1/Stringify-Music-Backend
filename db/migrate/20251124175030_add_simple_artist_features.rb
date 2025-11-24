class AddSimpleArtistFeatures < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :is_artist, :boolean, default: false
    add_column :songs, :is_public, :boolean, default: true
  end
end
