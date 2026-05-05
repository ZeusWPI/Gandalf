# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :cas_authenticatable, :omniauthable

  # Clubs the user is admin of
  has_many :clubs_users, dependent: nil # FKs will handle this
  has_many :clubs, through: :clubs_users

  # Clubs the user is enrolled in
  has_many :enrolled_clubs_members, dependent: nil # FKs will handle this
  has_many :enrolled_clubs, through: :enrolled_clubs_members, source: :club

  after_create :enqueue_fetch_club, :enqueue_fetch_enrolled_clubs

  # this should add all extra CAS attributes returned by the server to the current session
  # extra var in session: cas_givenname, cas_surname, cas_ugentstudentid, cas_mail, cas_uid (= UGent login)
  def cas_extra_attributes=(extra_attributes)
    extra_attributes.each do |name, value|
      # I prefer a case over reflection; this is safer if we suddenly get an
      # extra attribute without column
      case name.to_sym
      when :givenname
        self.cas_givenname = value
      when :surname
        self.cas_surname = value
      when :ugentStudentID
        self.cas_ugentstudentid = value
      when :mail
        self.cas_mail = value
      when :uid
        self.cas_uid = value
      end
    end

    self.save!

    if self.cas_ugentstudentid # rubocop:disable Style/GuardClause
      enqueue_fetch_club
      enqueue_fetch_enrolled_clubs
    end
  end

  # return Givenname + surname or username if these don't exist
  def display_name
    if cas_surname && cas_givenname
      "#{cas_givenname} #{cas_surname}"
    else
      username
    end
  end

  def enqueue_fetch_enrolled_clubs
    User::FetchEnrolledClubsJob.perform_later(id)
  end

  def enqueue_fetch_club
    User::FetchClubJob.perform_later(id)
  end

  # specifies the daily update for a users (enrolled) clubs
  def self.daily_update
    User.find_each do |u|
      User::FetchEnrolledClubsJob.set(wait: rand(240).minutes).perform_later(u.id)
      User::FetchClubJob.set(wait: rand(240).minutes).perform_later(u.id)
    end
  end

  def self.from_omniauth(auth)
    user = where(zeus_uid: auth.uid).first_or_create! do |u|
      u.username = auth.dig(:extra, :raw_info, :username)
      u.admin = auth.dig(:extra, :raw_info, :admin)
    end
    user.update!(admin: auth.dig(:extra, :raw_info, :admin))
    user
  end
end

# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  admin               :boolean
#  cas_givenname       :string
#  cas_mail            :string
#  cas_surname         :string
#  cas_ugentstudentid  :string
#  cas_uid             :string
#  current_sign_in_at  :datetime
#  current_sign_in_ip  :string
#  last_sign_in_at     :datetime
#  last_sign_in_ip     :string
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0), not null
#  username            :string           not null
#  zeus_uid            :string
#  created_at          :datetime
#  updated_at          :datetime
#
# Indexes
#
#  index_users_on_username  (username) UNIQUE
#
