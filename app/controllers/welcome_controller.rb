class WelcomeController < ApplicationController

  def index
    @valid_movies = movie_info
  end

end
