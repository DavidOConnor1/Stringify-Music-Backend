# app/controllers/api/v1/music_controller.rb
module Api
  module V1
    class MusicController < ApplicationController
      def search
        query = params[:query]
        service = params[:service] || 'itunes' # or 'deezer'
        
        if service == 'deezer'
          results = DeezerService.new.search_tracks(query)
        else
          results = ItunesService.new.search_tracks(query)
        end

        render json: {
          query: query,
          service: service,
          results: results
        }
      end
    end
  end
end