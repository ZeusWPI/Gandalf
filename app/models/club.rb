# frozen_string_literal: true

class Club < ApplicationRecord
  has_many :events, dependent: :destroy

  # Admins
  has_many :clubs_users, dependent: nil # FKs will handle this
  has_many :users, through: :clubs_users

  # Members
  has_many :enrolled_clubs_members, dependent: nil # FKs will handle this
  has_many :members, through: :enrolled_clubs_members, source: :user

  validates :internal_name, uniqueness: true

  def name
    full_name || display_name
  end
end

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
