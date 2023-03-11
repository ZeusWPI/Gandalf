# frozen_string_literal: true

require 'test_helper'

class FetchEnrolledClubsTest < ActiveSupport::TestCase
  def setup
    stub_request(:get, "http://registratie.fkgent.be/api/v2/members/clubs_for_ugent_nr.json")
      .with(query: { ugent_nr: "00800857", key: "#development#" })
      .to_return(body: '["zeus"]')

    stub_request(:get, "http://registratie.fkgent.be/api/v2/members/clubs_for_ugent_nr.json")
      .with(query: { ugent_nr: "", key: "#development#" })
      .to_return(body: '[]')
  end

  verify_fixtures User

  test "enrolled clubs is set after fetching" do
    tom = users(:tom)
    User::FetchEnrolledClubs.new(tom).call
    assert_equal tom.enrolled_clubs, [clubs(:zeus)]
  end
end
