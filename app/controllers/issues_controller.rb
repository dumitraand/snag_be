class IssuesController < ApplicationController
  before_action :authenticate

  def dashboard_issues
    @issues = @user.asigned_issues.order(:id)
    respond_to do |format|
      format.json {render :json => @issues.as_json(except: [:created_at, :updated_at])}
    end
  end

  def get_project_issues
    return if !get_project
    return if !check_user_project :project => @project
    @issues = @project.issues.order(:id)
    respond_to do |format|
      format.json {render :json => @issues.as_json(except: [:created_at, :updated_at])}
    end
  end

  def create_project_issue
    return if !get_project
    return if !check_user_project :project => @project
    @issue = create_issue
    if @issue.save
      respond_to do |format|
        format.json {render :json => @issue.as_json(except: [:created_at, :updated_at])}
      end
    end
  end

  def get_issue
    return if !get_issue_by_id
    return if !check_user_project :issue => @issue
    respond_to do |format|
      format.json {render :json => @issue.as_json(except: [:created_at, :updated_at])}
    end
  end

  def update_issue
    return if !get_issue_by_id
    return if !check_user_project :issue => @issue
    update_issue_params
    if @issue.save
      respond_to do |format|
        format.json {render :json => @issue.as_json(except: [:created_at, :updated_at])}
      end
    end
  end

  private

  def create_issue
    return Issue.new(
      :project => @project,
      :name => params[:name],
      :priority => params[:priority],
      :issue_code => rand.to_s[2..10],
      :story_points => params[:storyPoints],
      :sprint => params[:sprint],
      :label => params[:label],
      :description => params[:description],
      :environment => params[:environment],
      :reporter => @user,
      :creation_date => Time.now.to_f
    )
  end

  def update_issue_params
    @issue.name = params[:name] || @issue.name
    @issue.priority = params[:priority] || @issue.priority
    @issue.story_points = params[:storyPoints] || @issue.story_points
    @issue.sprint = params[:sprint] || @issue.sprint
    @issue.label = params[:label] || @issue.label
    @issue.description = params[:description] || @issue.description
    @issue.environment = params[:environment] || @issue.environment
    @issue.asignee_id = params[:assignee_id] || @issue.asignee_id
    @issue.status = params[:status] || @issue.status
  end

  def get_project
    @project = Project.find_by(:id => params[:project_id])
    if !@project.present?
      respond_to do |format|
        format.json {
          render :json => {
            errorMessage: "The project doesn't exist!"
          }.to_json,
          status: 400
        }
      end
      return false
    end
    return true
  end

  def get_issue_by_id
    @issue = Issue.find_by(:id => params[:issue_id])
    if !@issue.present?
      respond_to do |format|
        format.json {
          render :json => {
            errorMessage: "The issue doesn't exist!"
          }.to_json,
          status: 400
        }
      end
      return false
    end
    return true
  end

  def check_user_project(options={})
    if options[:issue].present?
      usr_prj = UserProject.find_by(:user => @user, :project => options[:issue].project)
    elsif options[:project].present?
      usr_prj = UserProject.find_by(:user => @user, :project => options[:project])
    end

    if !usr_prj.present?
      respond_to do |format|
        format.json {
          render :json => {
            errorMessage: "The user is not part of the corresponding project!"
          }.to_json,
          status: 401
        }
      end
      return false
    end
    return true
  end

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
