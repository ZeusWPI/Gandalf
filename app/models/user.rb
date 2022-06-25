# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  admin               :boolean
#  cas_givenname       :string
#  cas_mail            :string
#  cas_surname         :string
#  cas_ugentStudentID  :string
#  cas_uid             :string
#  current_sign_in_at  :datetime
#  current_sign_in_ip  :string
#  last_sign_in_at     :datetime
#  last_sign_in_ip     :string
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0), not null
#  username            :string           default(""), not null
#  created_at          :datetime
#  updated_at          :datetime
#
# Indexes
#
#  index_users_on_username  (username) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :cas_authenticatable, :omniauthable

  after_create :fetch_club, :fetch_enrolled_clubs

  has_and_belongs_to_many :clubs
  has_and_belongs_to_many :enrolled_clubs, join_table: :enrolled_clubs_members, class_name: "Club"

  # return the club this user can manage
  def fetch_club
    digest = ->(*args) { Digest::SHA256.hexdigest args.join('-') }

    # using httparty because it is much easier to read than net/http code
    resp = HTTParty.get("#{Rails.application.secrets.fk_auth_url}/#{username}/Gandalf",
                        headers: {
                          'X-Authorization' => Rails.application.secrets.fk_auth_key,
                          'Accept' => 'application/json'
                        })

    # this will only return the club names if control-hash matches
    # and timestamp roughly around our current server time (5 minute tolerance)

    return unless resp.success?

    hash = JSON[resp.body]
    clubs = hash['clubs'].map { |club| club['internal_name'] }
    timestamp = hash['timestamp']

    dig = digest.call(Rails.application.secrets.fk_auth_salt, username, timestamp, clubs)
    self.clubs = Club.where internal_name: clubs if (Time.zone.now - DateTime.parse(timestamp)).abs < 5.minutes && hash['sign'] == dig

    self.save!
  end

  # this should add all extra CAS attributes returned by the server to the current session
  # extra var in session: cas_givenname, cas_surname, cas_ugentStudentID, cas_mail, cas_uid (= UGent login)
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
        self.cas_ugentStudentID = value
      when :mail
        self.cas_mail = value
      when :uid
        self.cas_uid = value
      end
    end
    self.save!
  end

  # return Givenname + surname or username if these don't exist
  def display_name
    if cas_surname && cas_givenname
      "#{cas_givenname} #{cas_surname}"
    else
      username
    end
  end

  # fetch clubs where user is enrolled in
  def fetch_enrolled_clubs
    resp = HTTParty.get("http://registratie.fkgent.be/api/v2/members/clubs_for_ugent_nr.json", query:
                 { key: Rails.application.secrets.enrollment_key, ugent_nr: self.cas_ugentStudentID })

    return unless resp.code == 200

    clubs = JSON[resp.body].map(&:downcase).map { |c| c.gsub('-', '') }

    return if clubs.empty?

    self.enrolled_clubs = Club.where(internal_name: clubs)
    self.save!
  end

  # specifies the daily update for a users (enrolled) clubs
  def self.daily_update
    User.all.find_each(&:fetch_enrolled_clubs)
  end

  def self.from_omniauth(auth)
    where(username: auth.uid).first_or_create! do |user|
      user.username = auth.uid
    end
  end
end
