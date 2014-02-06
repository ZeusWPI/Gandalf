require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    # TODO: stub this properly
    stub_request(:get, "http://fkgent.be/api_isengard_v2.php").
      with(query: hash_including(u: 'tnnaesse')).
      to_return(body: '{"data":[{"internalName":"zeus","displayName":"Zeus WPI"},{"internalName":"zeus2","displayName":"Zeus WPI2"}],"controle":"78b385b6d773b180deddee6d5f9819771d6f75031c3ae9ea84810fa6869e1547"}')

    stub_request(:get, "http://fkgent.be/api_isengard_v2.php").
      with(query: hash_including(u: 'mjherthog')).
      to_return(body: '{"data":[{"internalName":"zeus","displayName":"Zeus WPI"},{"internalName":"zeus2","displayName":"Zeus WPI2"}],"controle":"78b385b6d773b180deddee6d5f9819771d6f75031c3ae9ea84810fa6869e1547"}')

    stub_request(:get, "http://fkgent.be/api_isengard_v2.php").
      with(query: hash_including(u: 'mherthoge')).
      to_return(body: '{"data":[{"internalName":"zeus","displayName":"Zeus WPI"},{"internalName":"zeus2","displayName":"Zeus WPI2"}],"controle":"78b385b6d773b180deddee6d5f9819771d6f75031c3ae9ea84810fa6869e1547"}')

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
