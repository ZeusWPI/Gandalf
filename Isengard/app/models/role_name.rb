# == Schema Information
#
# Table name: role_names
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class RoleName < ActiveRecord::Base
end
