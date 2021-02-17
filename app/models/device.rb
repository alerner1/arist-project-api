class Device < ApplicationRecord
  has_many :heartbeats
  has_many :reports
end
