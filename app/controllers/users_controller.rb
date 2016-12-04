class UsersController < ApplicationController
  respond_to :json

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
            loginError: "No such user or wrong password!"
          }.to_json,
          status: 400
        }
      end
    end
  end
end
