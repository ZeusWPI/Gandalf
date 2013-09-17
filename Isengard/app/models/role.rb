class Role < ActiveRecord::Base
  belongs_to :person
  belongs_to :event
  belongs_to :role_name
end
