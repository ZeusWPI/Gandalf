# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  username            :string           default(""), not null
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0), not null
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string
#  last_sign_in_ip     :string
#  created_at          :datetime
#  updated_at          :datetime
#  cas_givenname       :string
#  cas_surname         :string
#  cas_ugentStudentID  :string
#  cas_mail            :string
#  cas_uid             :string
#  admin               :boolean
#

require 'set'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :cas_authenticatable, :omniauthable

  after_create :fetch_club, :fetch_enrolled_clubs

  has_and_belongs_to_many :clubs
  has_and_belongs_to_many :enrolled_clubs, join_table: :enrolled_clubs_members, class_name: "Club"

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
    if cas_surname and cas_givenname
      cas_givenname + ' ' + cas_surname
    else
      username
    end
  end

  # fetch clubs where user is enrolled in
  def fetch_enrolled_clubs
    resp = HTTParty.get("http://registratie.fkgent.be/api/v2/members/clubs_for_ugent_nr.json", query:
                 {key: Rails.application.secrets.enrollment_key, ugent_nr: self.cas_ugentStudentID})

    if resp.code == 200
      clubs = JSON[resp.body].map(&:downcase).map {|c| c.gsub('-','')}
      if !clubs.empty?
        self.enrolled_clubs = Club.where(internal_name: clubs)
        self.save!
      end
    end
  end

  def fk_fetch_club
    fk_authorized_clubs = Set['chemica', 'dentalia', 'filologica', 'fk', 'gbk', 'geografica', 'geologica', 'gfk', 'hermes', 'hilok', 'khk', 'kmf', 'lila', 'lombrosiana', 'moeder-lies', 'oak', 'politeia', 'slavia', 'vbk', 'vdk', 'vek', 'veto', 'vgk-fgen', 'vgk-flwi', 'vlak', 'vlk', 'vppk', 'vrg', 'vtk', 'wina']
    resp = HTTParty.get("#{Rails.application.secrets.fk_auth_url}/#{username}/Gandalf",
                        headers: {
                          'X-Authorization' => Rails.application.secrets.fk_auth_key,
                          'Accept' => 'application/json'
                        })

    return Set.new unless resp.success?

    hash = JSON[resp.body]
    clubs = hash['clubs'].map { |club| club['internal_name'] }.to_set
    return clubs.filter {|club| fk_authorized_clubs.include?(club)}
  end

  def self.convert_dsa_to_fk_internal(clubname)
    {
      'vgeschiedk' => 'vgk-flwi',
      'vgeneesk' => 'vgk-fgen',
      'lies' => 'moeder-lies'
    }.fetch(clubname, clubname)
  end

  def self.update_clubs
    resp = HTTParty.get("https://dsa.ugent.be/api/verenigingen", headers: {"Authorization" => Rails.application.secrets.dsa_key})
    if resp.code != 200
      # TODO @veloxion: sentry loggen?
      return
    end
    dsa_clubs = JSON[resp.body]['associations']
    cas_to_dsa_associaions = Hash.new { |hash, key| hash[key] = Set[] }

    dsa_clubs.each do |club|
      if club.key?('board_members') then
        translated_club_id = self.convert_dsa_to_fk_internal(club['abbreviation'].downcase)
        club['board_members'].each do |user_object|
          cas_name = user_object['cas_name'].split('::')[1]
          cas_to_dsa_associaions[cas_name].add(translated_club_id)
        end

        if !Club.exists?(internal_name: translated_club_id) then
          new_club = Club.new do |c|
            c.internal_name = translated_club_id.downcase
            c.display_name = club['name']
            c.full_name = club['name']
          end
          new_club.save
        end
      end
    end

    cas_to_fk_associations = User.all.to_h {
      |user| [user.username, (user.fk_fetch_club + cas_to_dsa_associaions[user.username])]
    }
    cas_to_fk_associations.each do |cas_name, associations|
      user = User.where(username: cas_name).first
      if !user.nil? then
        user.clubs = Club.where internal_name: associations
        user.save!
      end
    end
  end

  # specifies the daily update for a users (enrolled) clubs
  def self.daily_update
    User.all.each do |user|
      user.fetch_enrolled_clubs
    end
    self.update_clubs
  end

  def self.from_omniauth(auth)
    where(username: auth.uid).first_or_create do |user|
      user.username = auth.uid
    end
  end
end
