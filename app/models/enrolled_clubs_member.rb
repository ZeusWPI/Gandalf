# frozen_string_literal: true

class EnrolledClubsMember < ApplicationRecord
  belongs_to :club
  belongs_to :user
end

# == Schema Information
#
# Table name: enrolled_clubs_members
#
#  club_id :bigint           not null
#  user_id :bigint           not null
#
# Indexes
#
#  idx_16894_index_enrolled_clubs_members_on_club_id              (club_id)
#  idx_16894_index_enrolled_clubs_members_on_club_id_and_user_id  (club_id,user_id) UNIQUE
#  idx_16894_index_enrolled_clubs_members_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (club_id => clubs.id) ON DELETE => cascade ON UPDATE => restrict
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade ON UPDATE => restrict
#
