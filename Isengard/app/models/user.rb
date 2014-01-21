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
#  club                :string(255)
#  cas_givenname       :string(255)
#  cas_surname         :string(255)
#  cas_ugentStudentID  :string(255)
#  cas_mail            :string(255)
#  cas_uid             :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :cas_authenticatable

  after_create :fetch_club

  # return the club this user can manage
  def fetch_club
    def digest(*args)
      Digest::SHA256.hexdigest args.join('-')
    end

    # using httparty because it is much easier to read than net/http code
    resp = HTTParty.get(Rails.application.config.fk_auth_url, :query => {
              :k => digest(username, Rails.application.config.fk_auth_key),
              :u => username
           })

    # this will only return the club name if control-hash matches
    if resp.body != 'FAIL'
      hash = JSON[resp.body]
      dig = digest(Rails.application.config.fk_auth_salt, username, hash['kringname'])
      self.club = hash['kringname'] if hash['controle'] == dig
      self.save!
    end
  end
end
