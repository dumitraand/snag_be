class UsersController < ApplicationController
  respond_to :json
  before_action :authenticate, :only => [:get_user_by_id]

  def login
    u, token = User.login(params[:username], params[:password])
    if u.present?
      respond_to do |format|
        format.json {render :json => User.fmt(u, token)}
      end
    else
      respond_to do |format|
        format.json {
          render :json => {
            errorMessage: "No such user or wrong password!"
          }.to_json,
          status: 400
        }
      end
    end
  end

  def get_user_by_id
    id = params[:user_id]
    u = User.find_by_id(id)
    if u.present?
      respond_to do |format|
        format.json {render :json => User.fmt(u, nil).except(:token)}
      end
    else
      respond_to do |format|
        format.json {
          render :json => {
            errorMessage: "No such user!"
          }.to_json,
          status: 400
        }
      end
    end
  end

  private

  def authenticate
    restrict_access || render_unauthorized
  end

  def restrict_access
    @user = authenticate_or_request_with_http_token do |token, options|
      User.check_token(token) || render_unauthorized
    end
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    respond_to do |format|
      format.json {render :json => {:errorMessage => "Please Login Again"}.as_json, :status => 401}
    end
  end
end
