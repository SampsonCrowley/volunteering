class StateStat < ApplicationRecord
  validates_uniqueness_of :state
end
