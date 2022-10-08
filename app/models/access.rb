# frozen_string_literal: true

class Access < ApplicationRecord
  belongs_to :access_level
  belongs_to :period, optional: true
  belongs_to :registration
end

# == Schema Information
#
# Table name: accesses
#
#  id              :integer          not null, primary key
#  created_at      :datetime
#  updated_at      :datetime
#  access_level_id :integer
#  period_id       :integer
#  registration_id :integer
#
# Indexes
#
#  index_accesses_on_access_level_id  (access_level_id)
#  index_accesses_on_period_id        (period_id)
#  index_accesses_on_registration_id  (registration_id)
#
