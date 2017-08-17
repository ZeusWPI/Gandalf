# == Schema Information
#
# Table name: clubs
#
#  id            :integer          not null, primary key
#  full_name     :string
#  internal_name :string
#  display_name  :string
#  created_at    :datetime
#  updated_at    :datetime
#

class Club < ActiveRecord::Base

  has_many :events

  has_and_belongs_to_many :users
  # enrolled_members, not admins
  has_and_belongs_to_many :members, join_table: :enrolled_clubs_members, class_name: 'User'

  validates :internal_name, uniqueness: true

  def name
    full_name ? full_name : display_name
  end

  def self.ordered_clubs
    # improve speed
    zeus = Club.where(internal_name: 'zeus').first
    ugent = Club.where(internal_name: 'ugent').first

    # ordering like it's 1999
    clubs = Club.except(zeus).except(ugent).sort_by {|c| c.name}
    [zeus, ugent] + clubs
  end
end
