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
  end

  verify_fixtures User

  # test "the truth" do
  #   assert true
  # end
end
