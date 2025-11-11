class HomeController < ApplicationController
    def index
        @artist = Artist.all
        render json: @artist
    end
end