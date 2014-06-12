require 'HTTParty'

class User < ActiveRecord::Base
  validates :phone_number, presence: true, length: {is: 10}
  validates :zip_code, presence: true, length: {is: 5}
  validate :phone_number_must_contain_only_numbers
  validate :zip_code_must_contain_only_numbers
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :interactions
  has_many :movies, through: :interactions


  def phone_number_must_contain_only_numbers
    int = phone_number.to_i
    int = int.to_s
    if int.length != phone_number.length
      errors.add(:phone_number, "must contain only numbers")
    end
  end

  def zip_code_must_contain_only_numbers
    int = zip_code.to_i
    int = int.to_s
    if int.length != zip_code.length
      errors.add(:zip_code, "must contain only numbers")
    end
  end

  def get_movie_list
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

    zip_code = self.zip_code.to_i
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
