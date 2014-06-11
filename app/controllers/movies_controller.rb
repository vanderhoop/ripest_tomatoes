require 'HTTParty'
require 'pry'

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

above_90_titles = unique_movies_above_90.map do |movie|
  movie["title"]
end
