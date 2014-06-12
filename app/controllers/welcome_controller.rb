class WelcomeController < ApplicationController

  def index
    binding.pry
    @valid_movies = movie_info
  end


end
