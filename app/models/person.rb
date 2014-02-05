# == Schema Information
#
# Table name: people
#
#  id         :integer          not null, primary key
#  username   :string(255)
#  password   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Person < ActiveRecord::Base
  has_many :roles, dependent: :destroy
  has_many :events, through: :roles
end
