# frozen_string_literal: true

class User
  class FetchClubJob < ApplicationJob
    queue_as :default

    def perform(user_id)
      user = User.find(user_id)

      User::FetchClub.new(user).call
    end
  end
end
