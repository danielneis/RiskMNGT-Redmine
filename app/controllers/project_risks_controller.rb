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

#Manages the risks of a specific project
class ProjectRisksController < BaseRiskApplicationController
  unloadable

  before_filter :find_project , :except => [:preview, :update_selectable_risks]
  before_filter :find_project_risk , :only => [:update, :delete, :show, :issues_new, :issues_index, :issues_delete]
  before_filter :require_login
  before_filter :authorize, :except => [:preview , :update_selectable_risks]
  verify :method => :post, :only => [:delete]

  helper :sort
  include SortHelper

  #Shows a paginated list of project risks which can be filtered via mitigation status, category, probability or impact
  def index
    @select_categories = RiskCategory.find :all, :conditions=>["status = ?", RiskCategory::STATUS_ACTIVE.to_i]

    @risk_mitigation_status = ( params[:risk] && has_value_params( params[:risk][:mitigation_status] ) ? params[:risk][:mitigation_status] : nil )
    @risk_category_id = ( params[:risk] && has_value_params( params[:risk][:risk_category_id] ) ? params[:risk][:risk_category_id] : nil )
    @risk_probability = ( params[:risk] && has_value_params( params[:risk][:probability] ) ? params[:risk][:probability] : nil )
    @risk_impact = ( params[:risk] && has_value_params( params[:risk][:impact] ) ? params[:risk][:impact] : nil )
    @exposure = ( params[:risk] && has_value_params( params[:risk][:exposure] ) ? params[:risk][:exposure] : nil )

    conditionStm = project_risk_query_condition
    limit = per_page_option

    @risk_count = ProjectRisk.count(:conditions => conditionStm)
    @risk_pages = Paginator.new self, @risk_count, limit, params['page']
    @risks = ProjectRisk.find :all, :conditions => conditionStm, :limit  => limit, :offset => @risk_pages.current.offset

    unless @exposure.nil?

     @valid_risks = Array.new

     @risks.each do |risk|
       @valid_risks << risk if risk.exposure == @exposure.to_i
     end

     @risks = @valid_risks
    end

    render :template => 'project_risks/index.rhtml', :layout => !request.xhr?
  end


  #If the request is a post and has the risk parameters,
  #it updates the new risk and when is successfully saved and redirects to index
  #Otherwise it redirects to the risk creation view.
  def create
    @project_risk = ProjectRisk.new
    edit( l(:notice_successful_create)  )
  end

  #Deletes a project risk
  def delete
    if @project_risk.destroy
      flash[:notice] = l(:notice_successful_delete)
    end

   redirect_to :action => 'index', :project_id => @project
  end

  #If the request is a post and has the project risk parameters,
  #it updates the project risk and if it is successfully saved and redirects to index
  #Otherwise it redirects to the risk update view.
  def update
    edit( l(:notice_successful_update) )
  end

  #Renders to "common/preview" either params[:project_risk][:mitigation]
  #when params[:opt] == 'mitigation' or params[:project_risk][:contingency] when params[:opt] == 'contingency'
  #It is intended to be used on Ajax request to preview a specific text area
  def preview
    if params[:opt] == 'mitigation'
      @text =  params[:project_risk][:mitigation]
    elsif params[:opt] == 'contingency'
      @text =  params[:project_risk][:contingency]
    end

    render :partial => 'common/preview'
  end

  #Redirects to the issues view of a specific project risk.
  #The view shows the issues relates to the project risk and gives the possibility of manage them.
  def issues_index
  end

  #Add a issue selected through params[:issue][:id], to the specific project risk, when it is not present.
  def issues_new
    super( params[:issue][:id] , @project_risk , @project )
  end

  #Delete a issue selected through params[:issue_id] from the specific project risk.
  def issues_delete
    super( params[:issue_id] , @project_risk , @project )
  end

  #Updates the variable _select_risk_ with all the risks which belongs to the risk category selected through  params[:project_risk_risk_category_id]
  #It is intended to be used on Ajax request to render partially to project_risks/select_risk
  def update_selectable_risks
    project_risk_id = params[:project_risk_id]
    setSelectableRisks( params[:project_risk_risk_category_id] )
    @project_risk = (project_risk_id.nil? || project_risk_id.blank? ) ? ProjectRisk.new : ProjectRisk.find(project_risk_id.to_i)
    render :partial => 'project_risks/select_risk', :locals => {:f=> @project_risk,  :selectable_risks => @select_risks }
  end

  private

  #Set _select_risks_ with all the risks with status active and belongs to a risk category whose id is equal to _risk_category_id_
  #* @param1= risk_category_id: identifier of a risk category.
  def setSelectableRisks(risk_category_id)
    @select_risks = Risk.find :all, :conditions=>["status = ? AND risk_category_id=?",Risk::STATUS_ACTIVE.to_i, risk_category_id ]
  end

  #If the request is a post and has the risk parameters (params[:risk][:name]....), it sets the properties of the _risk_ variable depending on the risk parametes and saves the item
  #When the item is sucessfully saved, it redirects to index.
  def edit( notice_successful )
    super( @project_risk ,  params[:project_risk] , notice_successful , @project )

    @select_categories = RiskCategory.find :all, :conditions=>["status = ?", RiskCategory::STATUS_ACTIVE.to_i]

    @project_risk.risk_category = @select_categories.first if @project_risk.risk_category.nil?

    setSelectableRisks( @project_risk.risk_category.id )
  end

  #Creates the query condition to be used on a project risk search
  def project_risk_query_condition
    # refactorable

    result = "project_id=#{@project.id} AND"
    result << " mitigation_status=#{@risk_mitigation_status} AND" if has_value_params( @risk_mitigation_status )
    result << " risk_category_id=#{@risk_category_id} AND" if has_value_params( @risk_category_id )
    result << " probability=#{@risk_probability} AND" if has_value_params( @risk_probability )
    result << " impact=#{@risk_impact} AND" if has_value_params( @risk_impact )

    result[0,result.length-3]
  end

  #Set the _project_risk_ variable depending on the _id_ and _project_id_ parameters
  #Renders to _render_404 when the _project_risk_ cannot be found
  def find_project_risk
    @project_risk = ProjectRisk.find params[:id], :conditions=>"project_id=#{@project.id}"
    rescue ActiveRecord::RecordNotFound
      render_404
  end
end
