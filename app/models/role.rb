# == Schema Information
#
# Table name: roles
#
#  id           :integer          not null, primary key
#  person_id    :integer
#  event_id     :integer
#  role_name_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Role < ActiveRecord::Base
  belongs_to :person
  belongs_to :event
  belongs_to :role_name
end
