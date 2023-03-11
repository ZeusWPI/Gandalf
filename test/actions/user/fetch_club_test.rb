# frozen_string_literal: true

require 'test_helper'

class FetchClubTest < ActiveSupport::TestCase
  def setup
    stub_request(:get, "https://intranet.fkgent.be/clubs/tnnaesse/Gandalf")
      .to_return(body: build_fk_response(:tnnaesse, %w[zeus zeus2]))

    stub_request(:get, "https://intranet.fkgent.be/clubs/mherthog/Gandalf")
      .to_return(body: build_fk_response(:mherthog, %w[fk]))

    stub_request(:get, "https://intranet.fkgent.be/clubs/tvwillem/Gandalf")
      .to_return(body: build_fk_response(:tvwillem, []))

    stub_request(:get, "https://dsa.ugent.be/api/verenigingen")
      .to_return(status: 200, body: {
        associations: [
          {
            abbreviation: "zeus",
            board_members: [
              {
                cas_name: "cas::tnnaesse",
                email: "Tom.Naessens@UGent.be",
                function: "Voorzitter"
              },
              {
                cas_name: "cas::unrelated",
                email: "Un.Related@UGent.be",
                function: "Vicevoorzitter"
              }
            ],
            description: "Zeus WPI is de studentenvereniging voor Informatica aan de Universiteit Gent. ...",
            dutch_description: "Zeus WPI is de studentenvereniging voor Informatica aan de Universiteit Gent. ...",
            email: "zeus@student.ugent.be",
            english_description: "Zeus WPI is the student association for Computer Science at Ghent University. ...",
            logo: "https://dsa.ugent.be/api/verenigingen/zeus/logo",
            name: "Zeus WerkgroeP Informatica",
            path: %w[dsa wvk],
            website: "https://zeus.ugent.be/"

          },
          {
            abbreviation: "stuw", # not all associations have a board visible to our API key
            description: "De facultaire studentenraad van de faculteit wetenschappen",
            dutch_description: "De facultaire studentenraad van de faculteit wetenschappen",
            email: "stuw@student.ugent.be",
            english_description: "De facultaire studentenraad van de faculteit wetenschappen",
            logo: "https://dsa.ugent.be/api/verenigingen/stuw/logo",
            name: "Studentenraad faculteit Wetenschappen",
            path: %w[gsr],
            website: "https://stuw.ugent.be"
          }
        ]
      }.to_json, headers: {})
  end

  verify_fixtures User

  test "clubs is set after fetching" do
    tom = users(:tom)
    tom.clubs = []

    assert_empty tom.clubs

    User::FetchClub.new(tom).call
    assert_not tom.clubs.empty?
    assert_equal tom.clubs, [clubs(:zeus)]

    maarten = users(:maarten)
    maarten.clubs = []

    assert_empty maarten.clubs

    User::FetchClub.new(maarten).call
    assert_not maarten.clubs.empty?
    assert_equal maarten.clubs, [clubs(:fk)]

    toon = users(:toon)
    toon.clubs = []

    assert_empty toon.clubs

    User::FetchClub.new(toon).call
    assert_empty toon.clubs
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
