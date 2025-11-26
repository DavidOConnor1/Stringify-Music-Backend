# app/controllers/api/v1/music_controller.rb
module Api
  module V1
    class MusicController < ApplicationController
      def search
        query = params[:query]
        limit = params[:limit] || 20

        if query.blank?
          render json: { error: 'Query parameter is required' }, status: :bad_request
          return
        end

        results = ItunesService.new.search_tracks(query, limit)

        render json: {
          query: query,
          results: results,
          total: results.size
        }
      end
    end
  end
end