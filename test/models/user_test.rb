# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    stub_request(:get, "https://intranet.fkgent.be/clubs/tnnaesse/Gandalf")
      .to_return(body: build_fk_response(:tnnaesse, %w[zeus zeus2]))

    stub_request(:get, "https://intranet.fkgent.be/clubs/mherthog/Gandalf")
      .to_return(body: build_fk_response(:mherthog, %w[fkcentraal]))

    stub_request(:get, "https://intranet.fkgent.be/clubs/tvwillem/Gandalf")
      .to_return(body: build_fk_response(:tvwillem, []))

    stub_request(:get, "http://registratie.fkgent.be/api/v2/members/clubs_for_ugent_nr.json")
      .with(query: { ugent_nr: "00800857", key: "#development#" })
      .to_return(body: '["zeus"]')

    stub_request(:get, "http://registratie.fkgent.be/api/v2/members/clubs_for_ugent_nr.json")
      .with(query: { ugent_nr: "", key: "#development#" })
      .to_return(body: '[]')
  end

  verify_fixtures User

  test "clubs is set after fetching" do
    tom = users(:tom)
    tom.clubs = []

    assert_empty tom.clubs

    tom.fetch_club
    assert_not tom.clubs.empty?
    assert_equal tom.clubs, [clubs(:zeus)]

    maarten = users(:maarten)
    maarten.clubs = []

    assert_empty maarten.clubs

    maarten.fetch_club
    assert_not maarten.clubs.empty?
    assert_equal maarten.clubs, [clubs(:fk)]

    toon = users(:toon)
    toon.clubs = []

    assert_empty toon.clubs

    toon.fetch_club
    assert_empty toon.clubs
  end

  test "enrolled clubs is set after fetching" do
    tom = users(:tom)
    tom.fetch_enrolled_clubs
    assert_equal tom.enrolled_clubs, [clubs(:zeus)]
  end

  private

  def build_fk_response(casname, clubs)
    timestamp = Time.zone.now
    sign = Digest::SHA256.hexdigest(
      [
        Rails.application.secrets.fk_auth_salt,
        casname,
        clean_json(timestamp),
        clubs
      ].join('-')
    )

    hash = {
      timestamp: timestamp,
      casname: casname,
      sign: sign,
      clubs: clubs.map do |club|
               {
                 internal_name: club
               }
             end
    }

    hash.to_json
  end

  # Converts input to it's json representation with beginning and starting quote stripped
  def clean_json(str)
    str.to_json.sub(/^\A"(.*)"\z$/, '\\1') # Make sure this is the same string that is sent in the JSON
  end
end

# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  admin               :boolean
#  cas_givenname       :string(255)
#  cas_mail            :string(255)
#  cas_surname         :string(255)
#  cas_ugentStudentID  :string(255)
#  cas_uid             :string(255)
#  current_sign_in_at  :datetime
#  current_sign_in_ip  :string(255)
#  last_sign_in_at     :datetime
#  last_sign_in_ip     :string(255)
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0), not null
#  username            :string(255)      not null
#  created_at          :datetime
#  updated_at          :datetime
#
# Indexes
#
#  index_users_on_username  (username) UNIQUE
#
