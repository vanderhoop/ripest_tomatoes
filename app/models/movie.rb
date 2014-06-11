class Movie < ActiveRecord::Base
  has_many :follows
end
