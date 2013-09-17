class ZoneAccess < ActiveRecord::Base
  belongs_to :zone
  belongs_to :period
  belongs_to :registration
end
