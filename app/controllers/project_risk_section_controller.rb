class ProjectRiskSectionController < RiskApplicationController
	unloadable
			
	before_filter :find_project #, :only => :index , :except => [:index, :changes, :gantt, :calendar, :preview, :update_form, :context_menu]
	before_filter :authorize, :only => :index
	before_filter :require_login
	
  def index
	  #if params[:project_id].nil?
		  #redirect_to :action => 'index', :tab => params[:tab]
	#	  return
	 # end	
  end

  def index2
	  	  	
  end
end
