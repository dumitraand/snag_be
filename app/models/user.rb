require 'jwt'
class User < ActiveRecord::Base
  has_secure_password
  SUPERUSER = 1
  USER = 2
  HMAC_SECRET = "cizu$$r@ullz123"

  ## CLASS METHODS
  def self.fmt(u, token)
    ###
    #Response: {
    #  user: { id, name, username, role },
    #  token: <string login token>
    #  }
    ###

    {
      user: {
        id: u.id,
        name: u.name,
        username: u.username,
        role: u.role
      },
      token: token
    }
  end

  def self.login(username, password)
    u = User.find_by_username(username)
    if u.present? && u.authenticate(password)
      exp = Time.now.to_i + 12 * 3600
      exp_payload = { :data => {:username => u.username}, :exp => exp }
      token = JWT.encode exp_payload, HMAC_SECRET, 'HS256'
      return u, token
    else
      return nil
    end
  end
  ## /CLASS METHODS
end
