# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  username            :string(255)      default(""), not null
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0), not null
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string(255)
#  last_sign_in_ip     :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  cas_givenname       :string(255)
#  cas_surname         :string(255)
#  cas_ugentStudentID  :string(255)
#  cas_mail            :string(255)
#  cas_uid             :string(255)
#  admin               :boolean
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    stub_request(:get, 'http://fkgent.be/api_isengard_v2.php')
      .with(query: hash_including(u: 'tnnaesse'))
      .to_return(body: '{"data":[{"internalName":"zeus","displayName":"Zeus WPI"},{"internalName":"zeus2","displayName":"Zeus WPI2"}],"controle":"78b385b6d773b180deddee6d5f9819771d6f75031c3ae9ea84810fa6869e1547"}')

    stub_request(:get, 'http://fkgent.be/api_isengard_v2.php')
      .with(query: hash_including(u: 'mherthog'))
      .to_return(body: '{"data":[{"internalName":"fkcentraal","displayName":"FaculteitenKonvent Gent"}],"controle":"aaa8c58fe85af272b980be8f0343bc2bb5b476b9a4917ba5ce9d1a1007436895"}')

    stub_request(:get, 'http://fkgent.be/api_isengard_v2.php')
      .with(query: hash_including(u: 'tvwillem'))
      .to_return(body: 'FAIL')

    stub_request(:get, 'http://registratie.fkgent.be/api/v2/members/clubs_for_ugent_nr.json')
      .with(query: { ugent_nr: '00800857', key: '#development#' })
      .to_return(body: '["zeus"]')

    stub_request(:get, 'http://registratie.fkgent.be/api/v2/members/clubs_for_ugent_nr.json')
      .with(query: { ugent_nr: '', key: '#development#' })
      .to_return(body: '[]')
  end

  test 'clubs is set after fetching' do
    tom = users(:tom)
    tom.clubs = []

    assert tom.clubs.empty?

    tom.fetch_club
    assert_not tom.clubs.empty?
    assert_equal tom.clubs, [clubs(:zeus)]

    maarten = users(:maarten)
    maarten.clubs = []

    assert maarten.clubs.empty?

    maarten.fetch_club
    assert_not maarten.clubs.empty?
    assert_equal maarten.clubs, [clubs(:fk)]

    toon = users(:toon)
    toon.clubs = []

    assert toon.clubs.empty?

    toon.fetch_club
    assert toon.clubs.empty?
  end

  test 'enrolled clubs is set after fetching' do
    tom = users(:tom)
    tom.fetch_enrolled_clubs
    assert_equal tom.enrolled_clubs, [clubs(:zeus)]
  end
end
