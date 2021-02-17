class Device < ApplicationRecord
  has_many :heartbeats
  has_many :reports

  validates :phone_number, phone: true

  def phone_number=(phone_number)
    phone_number = Phonelib.parse(phone_number)
    write_attribute(:phone_number, phone_number)
  end
end
