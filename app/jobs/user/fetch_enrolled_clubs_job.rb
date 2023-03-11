# frozen_string_literal: true

class User
  class FetchEnrolledClubsJob < ApplicationJob
    queue_as :default

    def perform(user_id)
      user = User.find(user_id)

      User::FetchEnrolledClubs.new(user).call
    end
  end
end
