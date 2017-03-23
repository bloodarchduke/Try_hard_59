class User < ApplicationRecord
  before_save {email.downcase!}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {maximum: 10}
  validate :check_phone_number
  validate :check_birthday, if: :is_valid_birthday?

  private

  def check_birthday
    errors.add :birthday, "Birthday have to be between 7 and 90 years before"
  end

  def is_valid_birthday?
    birthday &&
      (Time.now.year - birthday.year < 7 || Time.now.year - birthday.year > 90)
  end

  def check_phone_number
    if phone_number
      if !phone_number[0].eql? '0'
        errors.add :phone_number, "Phone number have to begin with 0"
      elsif phone_number.length != 10
        errors.add :phone_number, "Phone number have to have 10 digits"
      end
    end
  end
end
