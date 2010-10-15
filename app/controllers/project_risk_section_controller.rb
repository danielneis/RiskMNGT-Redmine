class ProjectRiskSectionController < RiskApplicationController
  unloadable
  before_filter :find_project
  before_filter :authorize, :only => :index
  before_filter :require_login
	
  def index
  end

  def index2
  end
end
