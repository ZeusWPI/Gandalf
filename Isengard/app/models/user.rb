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
