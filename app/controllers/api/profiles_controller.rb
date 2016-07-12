class Api::ProfilesController < ActionController::Base
  respond_to :json

  ## GET
  def index
    @profiles = Profile.includes(:experiences, :educations).all
  end

  def show
    # params[:id] can be either sql id or uuid 
    @profile = Profile.find_by_id(params[:id]) || Profile.find_by_uuid(params[:id])
    if @profile.nil?
      render :json => {:message => "Profile does not exists. You can pass either the id or uuid of the user"}, :status => 400
    end
  end

  ## POST
  ## Adding the give profile to the database if such exists.
  ## username (string) attribute must be passed.
  def create
    @username_candidate = params[:username]

    if @username_candidate.present?
      @profile = Profile.new(:uuid => @username_candidate)
      if @profile.enqueue
        render :json => {:message => "The profile is being processed. Use the profile uuid to track the process status", :uuid => @profile.uuid, :id => @profile.id}
      else
        render :json => {:message => "Operation could not be completed.", :error => @profile.errors.full_messages.join(". ")}, :status => 400
      end
    else
      render :json => {:message => "Please pass a username"}, :status => 400
    end
  end

  ## GET
  ## Returns the resulted profiles by the search query
  ## searchable columns: 
  def search
    # pagination??
    if params[:q].present?
      enhance_search_params
      p params[:q]
      @q = Profile.ransack(params[:q])
      @profiles = @q.result.includes(:experiences, :educations)
    else
      render :json => {:message => "You must pass 'q' parameter with the desire filters. You can search by full_name, title, current_position, skills and summary"}
    end
  end

private 

  def enhance_search_params
    q = params[:q]
    q[:full_name_cont] = q.delete(:full_name) if q[:full_name].present?
    q[:summary_cont] = q.delete(:summary) if q[:summary].present?
    q[:title_cont] = q.delete(:title) if q[:title].present?
    q[:current_position_cont] = q.delete(:current_position) if q[:current_position].present?
    # skills will be sent as a comma seperated string
    q[:skills_overlap] = q.delete(:skills).split(",").collect {|skill| skill.strip} if q[:skills].present?
  end
end
