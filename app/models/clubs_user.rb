# frozen_string_literal: true

class ClubsUser < ApplicationRecord
  belongs_to :club
  belongs_to :user
end

# == Schema Information
#
# Table name: clubs_users
#
#  club_id :bigint
#  user_id :bigint
#
# Indexes
#
#  idx_16891_fk_rails_b7c6964840                       (user_id)
#  idx_16891_index_clubs_users_on_club_id_and_user_id  (club_id,user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (club_id => clubs.id) ON DELETE => cascade ON UPDATE => restrict
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade ON UPDATE => restrict
#
