class MusicLibrary
  def initialize
    @delegate = Library::Music::MusicLibrary.new
  end

  def get_featured_artists
    @delegate.get_featured_artists
  end

  def get_featured_songs
    @delegate.get_featured_songs
  end

  def search_songs(query, limit = 20)
    @delegate.search_songs(query, limit)
  end

  def get_new_releases
    @delegate.get_new_releases
  end
end