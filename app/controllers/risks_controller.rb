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

#Manages the system risks
class RisksController < BaseRiskApplicationController
  unloadable

  before_filter :require_login
  before_filter :authorize_global, :except => [:preview, :retrieve]
  before_filter :find_risks, :only => [:update, :delete, :retrieve]
  verify :method => :post, :only => [:delete]

  #It shows a paginated list of risks which can be filtered via risk status and risk category
  def index

    @risk_status = ( params[:risk] ? params[:risk][:status] : nil )
    @risk_category_id = ( params[:risk] ? params[:risk][:risk_category_id] : nil )

    @select_categories = RiskCategory.find :all

    risks_search

     # Template rendering works just like action rendering except that it takes a path relative to the template root. The current layout is automatically applied.
    render :template => 'risks/index.rhtml', :layout => !request.xhr?
  end

  #If the request is a post and has the risk parameters (params[:risk][:name]....), it updates the new risk and when is successfully saved, redirects to index
  #Otherwise it redirects to the risk creation view.
  def create
    @risk = Risk.new
    edit( l(:notice_successful_create) )
  end

  #It executes _find_risks_ and shows the view of the specific risk
  def retrieve
  end

  #If the request is a post and has the risk parameters (params[:risk][:name]....), it updates the risk and if it is successfully saved, redirects to index
  #Otherwise it redirects to the risk update view.
  def update
    edit( l(:notice_successful_update) )
  end

  #Destroys the risk specified on param[:id] when the risk has no associated project risks.
  def delete

    p_risks = ProjectRisk.find :all,
               :conditions=>['risk_id=?', @risk.id]

    if !p_risks.nil? && p_risks.size > 0
      flash[:error] = l(:not_allowed_to_delete_risk_with_associated_project_risks_label)
    elsif @risk.destroy
      flash[:notice] = l(:notice_successful_delete)
    end

   redirect_to :action => 'index'
  end

  #It renders to "common/preview" either params[:risk][:mitigation] when params[:opt] == 'mitigation' or params[:risk][:contingency] when params[:opt] == 'contingency'
  #It is intended to be used on Ajax request to preview a specific text area
  def preview
    if params[:opt] && params[:risk]
      if params[:opt] == 'mitigation'
        @text =  params[:risk][:mitigation]
      elsif params[:opt] == 'contingency'
        @text =  params[:risk][:contingency]
      end
    end
    render :partial => 'common/preview'
  end

  #If the request is a post and has the risk parameters (params[:risk][:name]....), it sets the properties of the _risk_ variable depending on the risk parametes and saves the item
  #When the item is sucessfully saved, it redirects to index
  private
  def edit( notice_successful )
    super(@risk ,  params[:risk] , notice_successful)
    @select_categories = RiskCategory.find :all
  end

  #Set the _risk_ variable depending on the _id_ parameter
  #It renders to _render_404 when the _risk_ cannot be found
  def find_risks
    @risk = Risk.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_404
  end
end
