class ProjectsController < ApplicationController
  before_action :authenticate

  def get_user_projects
    @projects = @user.projects
    respond_to do |format|
      format.json {render :json => @projects.as_json(except: [:created_at, :updated_at])}
    end
  end

  private

  protected
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
