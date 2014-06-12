class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :phone_number
    devise_parameter_sanitizer.for(:sign_up) << :zip_code

  end

  def movie_info
    in_theater_movies_1 = HTTParty.get("http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=#{ROTTEN_TOMATOES_API_KEY}&page_limit=50&page=1")
    in_theater_movies_2 = HTTParty.get("http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=#{ROTTEN_TOMATOES_API_KEY}&page_limit=50&page=2")
    in_theater_movies_3 = HTTParty.get("http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=#{ROTTEN_TOMATOES_API_KEY}&page_limit=50&page=3")
    in_theater_movies_4 = HTTParty.get("http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=#{ROTTEN_TOMATOES_API_KEY}&page_limit=50&page=4")
    response_1 = JSON(in_theater_movies_1)
    response_2 = JSON(in_theater_movies_2)
    response_3 = JSON(in_theater_movies_3)
    response_4 = JSON(in_theater_movies_4)
    movies_1 = response_1["movies"]
    movies_2 = response_2["movies"]
    movies_3 = response_3["movies"]
    movies_4 = response_4["movies"]

    all_movies = movies_1 + movies_2 + movies_3 + movies_4
    unique_movies = all_movies.uniq

    unique_movies_above_90 = unique_movies.select do |movie|
      movie["ratings"]["critics_score"] >= 90
    end

    zip_code = 20001
    radius = 5
    radius_units = 'mi'
    today = Time.now.strftime("%F")

    results = HTTParty.get("http://data.tmsapi.com/v1/movies/showings?startDate=#{today}&zip=#{zip_code}&radius=#{radius}&units=#{radius_units}&api_key=#{ON_CONNECT_API_KEY}")

    zip_showings = results.map do |result|
      result["title"]
    end

    # critics aggregate rating in %
    # movie title
    # rotten tomatoes id
    # genre
    # parental guidance rating

    final_array = unique_movies_above_90.select do |movie|
      zip_showings.include?(movie["title"])
    end
  end
end
