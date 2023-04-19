# frozen_string_literal: true

require 'set'

class User
  class FetchClub
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def call
      dsa_managed = dsa_fetch_club
      fk_managed = fk_fetch_club
      permitted_clubs = dsa_managed + fk_managed
      user.clubs = Club.where internal_name: permitted_clubs
      user.save!
    end

    private

    def fk_fetch_club
      fk_authorized_clubs = Set['chemica', 'dentalia', 'dsa', 'filologica', 'fk', 'gbk', 'geografica', 'geologica', 'gfk', 'hermes', 'hilok',
                                'khk', 'kmf', 'lila', 'lombrosiana', 'moeder-lies', 'oak', 'politeia', 'slavia', 'vbk', 'vdk', 'vek', 'veto',
                                'vgk-fgen', 'vgk-flwi', 'vlak', 'vlk', 'vppk', 'vrg', 'vtk', 'wina']
      resp = HTTParty.get(
        "#{Rails.application.secrets.fk_auth_url}/#{user.username}/Gandalf",
        headers: {
          'X-Authorization' => Rails.application.secrets.fk_auth_key,
          'Accept' => 'application/json'
        }
      )

      return Set.new unless resp.success?

      hash = JSON[resp.body]
      clubs = hash['clubs'].to_set { |club| club['internal_name'].downcase }
      # Only return clubs FK can manage
      clubs & fk_authorized_clubs
    end

    def convert_dsa_to_fk_internal(clubname)
      {
        'vgeschiedk' => 'vgk-flwi',
        'vgeneesk' => 'vgk-fgen',
        'lies' => 'moeder-lies'
      }.fetch(clubname, clubname)
    end

    def dsa_fetch_club
      # The DSA API request is fairly heavy (~80kb), so we cache it for 5 minutes
      cas_to_dsa_associations = Rails.cache.fetch("dsa_api_response", expires_in: 5.minutes, skip_nil: true) do
        api_response = HTTParty.get("https://dsa.ugent.be/api/verenigingen", headers: { "Authorization" => Rails.application.secrets.dsa_key })
        next if api_response.code != 200

        return_map = Hash.new { |hash, key| hash[key] = Set[] }
        JSON[api_response.body]['associations'].each do |club|
          # We don't have access to the board members of all clubs, so skip the club if don't see board members
          next unless club.key?('board_members')

          # The DSA API uses slightly different IDs than FK
          translated_club_id = convert_dsa_to_fk_internal(club['abbreviation'].downcase)

          # Create club (this has to happen here, since we need to access the readable name)
          Club.find_or_create_by!(internal_name: translated_club_id.downcase) do |c|
            c.display_name = club['name']
            c.full_name = club['name']
          end

          club['board_members'].each do |user_object|
            cas_name = user_object['cas_name'].split('::')[1]
            return_map[cas_name].add(translated_club_id)
          end
        end
        return_map.default = nil # clear the default_proc since it can't be serialized
        next return_map
      end

      return Set.new if cas_to_dsa_associations.nil?

      cas_to_dsa_associations.fetch(user.username, Set[])
    end
  end
end
