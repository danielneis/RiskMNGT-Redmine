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

#=RisksController
#===It manages the system risk categories
class RiskCategoriesController < BaseRiskApplicationController
	unloadable		
	
	before_filter :require_login
	before_filter :authorize_global , :except => [:retrieve]	
	before_filter :find_risk_category, :only => [:update, :delete, :retrieve]
	verify  :method => :post,
		:only => :delete
		
	

  #=index
  #===It shows the list of risk categories
  def index
	  @categories = RiskCategory.find :all	  	
  end

  #=create
  #===If the request is a post and has the risk category parameters (params[:category][:name]....), it updates the new risk and when it is successfully saved, redirects to index
  #===Otherwise it redirects to the risk category creation view.	
  def create	  	  	   	
	  @category = RiskCategory.new(:status => RiskCategory::STATUS_ACTIVE)	  	  	
	  edit( @category ,  params[:category] , l(:notice_successful_create) )
  end

  #=retrieve
  #=== It executes _find_risk_category_ and shows the view of the specific risk category
  def retrieve
	  	  	
  end

  #=update
  #===If the request is a post and has the risk category parameters (params[:category][:name]....), it updates the category and if it is successfully saved, redirects to index
  #===Otherwise it redirects to the risk category update view.
  def update		    	  	
	  edit( @category ,  params[:category] , l(:notice_successful_update) )
  end

	
  #=delete
  #===It destroys the risk specified on param[:id] when the category has no associated project risks or associated well-known risks.
  def delete	  	
	
	  p_risks = ProjectRisk.find :all,
	  			     :conditions=>['risk_category_id=?', @category.id]
	  		
	  if !p_risks.nil? && p_risks.size > 0
		  flash[:error] = l(:not_allowed_to_delete_category_with_associated_project_risks_label)		  	 	
	  elsif @category.risks.count > 0		
		  flash[:error] = l(:not_allowed_to_delete_category_with_associated_risks_label)
	  elsif @category.destroy
		  flash[:notice] = l(:notice_successful_delete) 		
	  end	
	
	 redirect_to :action => 'index'
  end


  #------------------------------- private

  #==find_risk_category
  #===Set the _category_ variable depending on the _id_ parameter
  #===It renders to _render_404 when the _category_ cannot be found
  def find_risk_category
	  @category = RiskCategory.find(params[:id])
  	  rescue ActiveRecord::RecordNotFound
	  	  render_404	
  end


end
