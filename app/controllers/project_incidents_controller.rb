#  Copyright (C) 2009 Isotrol S.A.
#  Contribution: Nicolas Bertet, Chief project. José Cano Ruiz, Developer.
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published
#  by the Free Software Foundation; either version 3 of the License, or
#  any later version.
#
#  This program is distributed in the hope that it will be useful, but
#  WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
#  Public License for more details.
#
#  You should have received a copy of the GNU General Public License along
#  with this program. If not, see <http://www.gnu.org/licenses/>, or contact
#  us at Isotrol S.A. Edificio BLUENET. Avda. Isaac Newton nº 3, 4ª planta.
#  Parque Tecnológico Cartuja ´93, 41092 Sevilla.
#
#  *************************************************************************
#
#  Licensed under the EUPL, Version 1.1 or – as soon they will be approved by
#  the European Commission – subsequent versions of the EUPL (the "Licence");
#  you may not use this work except in compliance with the Licence.
#
#  You may obtain a copy of the Licence at: http://ec.europa.eu/idabc/7330l5
#  or contact us at Isotrol S.A. Edificio BLUENET. Avda. Isaac Newton nº 3,
#  4ª planta. Parque Tecnológico Cartuja ´93, 41092 Sevilla
#
#  Unless required by applicable law or agreed to in writing, software distributed
#  under the Licence is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#  CONDITIONS OF ANY KIND, either express or implied.
#
#  See the Licence for the specific language governing permissions and limitations
#  under the Licence.

#Manages the incidents of a specific project
class ProjectIncidentsController < BaseRiskApplicationController
  menu_item :risks

  before_filter :find_project , :except => [:preview]
  before_filter :find_project_incident , :only => [:update, :delete, :show, :issues_new, :issues_index, :issues_delete]
  before_filter :require_login
  before_filter :authorize, :except => [:preview]
  verify :method => :post, :only => [:delete]

  helper :project_risks
  include ProjectRisksHelper

  #Shows a paginated list of project incidents which can be filtered via ....
  def index

    @incident_correction_status = ( params[:incident] && has_value_params( params[:incident][:correction_status] ) ? params[:incident][:correction_status] : nil )
    @incident_impact = ( params[:incident] && has_value_params( params[:incident][:impact] ) ? params[:incident][:impact] : nil )


    conditionStm = project_incident_query_condition
    limit = per_page_option

    @incident_count = ProjectIncident.count(:conditions => conditionStm)
    @incident_pages = Paginator.new self, @incident_count, limit, params['page']
    @incidents = ProjectIncident.find :all,:conditions => conditionStm , :limit  => limit,
                                      :offset => @incident_pages.current.offset
                                      #:order => sort_clause, it could be added, but complex

    render :template => 'project_incidents/index.rhtml', :layout => !request.xhr?
  end

  #If the request is a post and has the risk parameters, it updates the new risk and when is successfully saved, redirects to index
  #Otherwise it redirects to the risk creation view.
  def create
    @incident = ProjectIncident.new
    edit( @incident ,  params[:incident] , l(:notice_successful_create) , @project )
  end

  #Shows the view of a specific project risk
  def show 
  end

  #Deletes a project incident
  def delete
    if @incident.destroy
      flash[:notice] = l(:notice_successful_delete)
    end
    redirect_to :action => 'index', :project_id => @project
  end

  #If the request is a post and has the project incident parameters,  the project incidence is updated and if it is successfully saved, redirects to index
  #Otherwise it redirects to the incidence update view.
  def update
    edit( @incident ,  params[:incident] , l(:notice_successful_update) , @project )
  end

  #Renders to "common/preview" to show the incident correction
  #It is intended to be used on Ajax request to preview a specific text area
  def preview
    @text =  params[:incident][:correction] if params[:incident]
    render :partial => 'common/preview'
  end

  #Redirects to the issues view of a specific project risk.
  #The view shows the issues relates to the project risk and gives the possibility of manage them.
  def issues_index
  end

  #Add an issue selected through params[:issue][:id], to the specific project risk, when it is not present.
  def issues_new
    super( params[:issue][:id] , @incident , @project )
  end


  #Delete an issue selected through params[:issue_id] from the specific project risk.
  def issues_delete
    super(params[:issue_id], @incident, @project)
  end

  private
  #Creates the query condition to be used on a project incident search
  def project_incident_query_condition
    # refactorable

    result = "project_id=#{@project.id} AND"
    result << " correction_status=#{@incident_correction_status} AND" if has_value_params( @incident_correction_status )
    result << " impact=#{@incident_impact} AND" if has_value_params( @incident_impact )

    result[0,result.length-3]
  end

  #Set _incident_ depending on the _id_ and _project_id_ parameters
  #It renders to _render_404 when the _id_ cannot be found
  def find_project_incident
    @incident = ProjectIncident.find params[:id], :conditions=>"project_id=#{@project.id}"
    rescue ActiveRecord::RecordNotFound
      render_404
  end
end
