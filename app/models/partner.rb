# == Schema Information
#
# Table name: partners
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  email                :string(255)
#  authentication_token :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

class Partner < ActiveRecord::Base
  has_paper_trail
end
