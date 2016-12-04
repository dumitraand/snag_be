require 'jwt'
class User < ActiveRecord::Base
  has_secure_password

  has_many :user_projects
  has_many :projects, through: :user_projects
  has_many :reported_issues, class_name: "Issue", foreign_key: "reporter_id"
  has_many :asigned_issues, class_name: "Issue", foreign_key: "asignee_id"

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

  def self.check_token(token)
    begin
      decoded_token = JWT.decode token, HMAC_SECRET, true, { :algorithm => 'HS256' }
      return User.find_by_username(decoded_token.first["data"]["username"])
    rescue JWT::ExpiredSignature
      false
    end
  end
  ## /CLASS METHODS
end
