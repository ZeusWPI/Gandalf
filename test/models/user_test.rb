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
    create(:club_zeus)
    create(:club_fk)

    tom = build(:user, username: 'tnnaesse')
    assert_empty tom.clubs

    tom.fetch_club
    assert_not_empty tom.clubs
    assert_equal tom.clubs, [Club.find_by_internal_name(:zeus)]

    maarten = build(:user, username: 'mherthog')
    assert_empty maarten.clubs

    maarten.fetch_club
    assert_not maarten.clubs.empty?
    assert_equal maarten.clubs, [Club.find_by_internal_name(:fkcentraal)]

    toon = build(:user, username: 'tvwillem')
    assert_empty toon.clubs

    toon.fetch_club
    assert_empty toon.clubs
  end

  test 'enrolled clubs is set after fetching' do
    create(:club_zeus)

    tom = build(
      :numbered_user,
      username: 'tnnaesse',
      cas_ugentStudentID: '00800857'
    )
    tom.fetch_enrolled_clubs
    assert_equal tom.enrolled_clubs, [Club.find_by_internal_name(:zeus)]
  end
end
