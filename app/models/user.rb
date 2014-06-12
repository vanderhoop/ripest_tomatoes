class User < ActiveRecord::Base
  validates :phone_number, presence: true, length: {is: 10}
  validate :phone_number_must_contain_only_numbers
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

end
