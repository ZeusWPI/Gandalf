# frozen_string_literal: true

class User
  class FetchEnrolledClubs
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def call
      resp = HTTParty.get("http://registratie.fkgent.be/api/v2/members/clubs_for_ugent_nr.json", query:
        { key: Rails.application.secrets.enrollment_key, ugent_nr: user.cas_ugentStudentID })

      return unless resp.code == 200

      clubs = JSON[resp.body].map(&:downcase).map { |c| c.gsub('-', '') }

      return if clubs.empty?

      user.enrolled_clubs = Club.where(internal_name: clubs)
      user.save!
    end
  end
end
