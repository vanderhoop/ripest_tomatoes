class WelcomeController < ApplicationController
  include MovieData

  def index
    binding.pry
    # shows top movies by default
  end


end
