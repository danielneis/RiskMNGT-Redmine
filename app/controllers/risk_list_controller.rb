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


#=RiskListController
#===It manages the list of well-known risks to be shown on the project risk section.
class RiskListController < BaseRiskApplicationController
	unloadable
	
	before_filter :find_project
	before_filter :require_login
	before_filter :authorize
	
			

  #=index
  #===It shows a list of well-known risks which can be filtered via category.	
  def index
	  @risk_status = Risk::STATUS_ACTIVE.to_i
	  @risk_category_id =( params[:risk] ? params[:risk][:risk_category_id] : nil )
	  	  	  	  	  	
	  @select_categories = RiskCategory.find :all,
	  				:conditions=>["status = ?", RiskCategory::STATUS_ACTIVE.to_i]
	
	  return render_404 if !@select_categories.nil? && @select_categories.size > 0 && @risk_category_id && !exist(  @select_categories , @risk_category_id )
		  	
	  risks_search	  	
			   			
 	  # Template rendering works just like action rendering except that it takes a path relative to the template root. The current layout is automatically applied. 				
	  render :template => 'risk_list/index.rhtml', :layout => !request.xhr?	   		
  end



end
