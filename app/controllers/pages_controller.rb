class PagesController < ApplicationController
  def home
    render json: {
      app: "Stringify Music API",
      status: "operational",
      database: ActiveRecord::Base.connected? ? "connected" : "disconnected",
      time: Time.now.iso8601
    }
  end
end
