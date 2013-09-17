class IncludedZone < ActiveRecord::Base
  belongs_to :zone
  belongs_to :access_level
end
