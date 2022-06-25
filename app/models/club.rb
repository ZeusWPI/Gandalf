# frozen_string_literal: true

# == Schema Information
#
# Table name: clubs
#
#  id            :integer          not null, primary key
#  display_name  :string
#  full_name     :string
#  internal_name :string
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_clubs_on_internal_name  (internal_name) UNIQUE
#

class Club < ApplicationRecord
  has_many :events

  has_and_belongs_to_many :users
  # enrolled_members, not admins
  has_and_belongs_to_many :members, join_table: :enrolled_clubs_members, class_name: 'User'

  validates :internal_name, uniqueness: true

  def name
    full_name || display_name
  end
end
