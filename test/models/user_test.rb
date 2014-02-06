require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    stub_request(:get, "http://fkgent.be/api_isengard_v2.php").
      with(query: hash_including(u: 'tnnaesse')).
      to_return(body: '{"data":[{"internalName":"zeus","displayName":"Zeus WPI"},{"internalName":"zeus2","displayName":"Zeus WPI2"}],"controle":"78b385b6d773b180deddee6d5f9819771d6f75031c3ae9ea84810fa6869e1547"}')

    stub_request(:get, "http://fkgent.be/api_isengard_v2.php").
      with(query: hash_including(u: 'mherthog')).
      to_return(body: '{"data":[{"internalName":"fkcentraal","displayName":"FaculteitenKonvent Gent"}],"controle":"aaa8c58fe85af272b980be8f0343bc2bb5b476b9a4917ba5ce9d1a1007436895"}')

    stub_request(:get, "http://fkgent.be/api_isengard_v2.php").
      with(query: hash_including(u: 'tvwillem')).
      to_return(body: 'FAIL')

    stub_request(:get, "http://registratie.fkgent.be/api/v2/members/clubs_for_ugent_nr.json").
      with(query: {ugent_nr: "00800857", key: "#development#"}).
      to_return(body: '["zeus"]')

    stub_request(:get, "http://registratie.fkgent.be/api/v2/members/clubs_for_ugent_nr.json").
      with(query: {ugent_nr: "", key: "#development#"}).
      to_return(body: '[]')
  end

  verify_fixtures User

  test "enrolled clubs is set after fetching" do
    tom = users(:tom)
    tom.fetch_enrolled_clubs
    assert_equal tom.enrolled_clubs, [clubs(:zeus)]
  end

end
