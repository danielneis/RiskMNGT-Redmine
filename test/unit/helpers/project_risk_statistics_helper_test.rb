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

require File.dirname(__FILE__) + '/../../test_helper'

class ProjectRiskStatisticsHelperTest < Test::Unit::TestCase

  include ProjectRiskStatisticsHelper
  include ProjectRisksHelper

    	 		
  def test_compose_rows
	  #plugin_create_fixtures( ['risk_categories','risks','projects','users',
	 # 	  'members' , 'roles' , 'enabled_modules','project_risks','issues' , 'trackers',
	#	  'projects_trackers', 'issue_statuses','issue_categories','enumerations'] )
	
	 # data = ActiveRecord::Base.connection.select_all("select  mitigation_status as value,
          #                                              count(id) as count
           #                                     from #{ProjectRisk.table_name} 						
            #                                    where project_id=#{@project_id}
             #                                   group by mitigation_status ")
	
	  translations = mitigation_status_choices
	
	  data = Array.new
	  mitigation_status_values.each_key do |key|
		  h = {}
		  h['value'] = key.to_i
		  h['count'] = key.to_i
		  data << h
	  end
	
	  	  		  		  		  	  	  	  	  	  	
	  rows = compose_rows(data, translations)
	
	  rows.each do |row|
	 	  assert row.name , translations[row.value.to_i]		
	  end
	  	  	  	  	  	
  end


  def test_compose_rows_return_rows_for_all_translations
	
	  translations = mitigation_status_choices
	  	   		  	  	    	
	  data = [{ "value" => 1, "count" => 2 } , { "value" => 2, "count" => 1 }]
		  		  		  	  	  	  	  	  	
	  rows = compose_rows(data, translations)
	
	  assert_equal translations.size , rows.size
	
	  data = [{ "value" => 1, "count" => 2 } ]
		  		  		  	  	  	  	  	  	
	  rows = compose_rows(data, translations)
	
	  assert_equal translations.size , rows.size
	  	  	  	  	  	
  end

end

