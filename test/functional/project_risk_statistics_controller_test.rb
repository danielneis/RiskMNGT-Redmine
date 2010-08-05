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

require File.dirname(__FILE__) + '/../test_helper'

class ProjectRiskStatisticsControllerTest < ActionController::TestCase
	
  def setup	  	  	
    plugin_create_fixtures( ['risk_categories','risks','projects','users',
		  'members' , 'roles' , 'enabled_modules','project_risks','issues' , 'trackers',
		  'projects_trackers', 'issue_statuses','issue_categories','enumerations'] )
    #puts_info

    @controller = ProjectRiskStatisticsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @project_id = "1"

    User.current = nil
    set_session_user_id('admin')
  end

  def teardown	  	
	Fixtures.reset_cache  		
  end	


  def test_index_permissions	
       test_index_permission_project_risk(@project_id)
  end

  def test_index_permissions_without_enabled_risk_project_module
      test_index_permission_project_risk_without_enabled_risk_project_module(3)
  end

  def test_index_tab_value_range
	
	  [
	  {'tab'=>'risk_exposure', 'report_name'=>l(:risk_exposure_label)},
	  {'tab'=>'risk_impact', 'report_name'=>l(:risk_impact_label)},
	  {'tab'=>'risk_probability', 'report_name'=> l(:field_probability)},
	  {'tab'=>'risk_status', 'report_name'=> l(:field_mitigation_status)},
	  {'tab'=>'risk_category', 'report_name'=> l(:risk_category_label)},
	  {'tab'=>'incident_status', 'report_name'=> l(:field_correction_status)},
	  {'tab'=>'incident_impact', 'report_name'=> l(:incident_impact_label)}	
	  ].each do |item|		
		  get :index , :project_id=>@project_id , :tab=>item['tab']
		  assert_response :success, "not allowed??"		
		  assigns_index_variables		
		  assert_equal assigns(:report_name) , item['report_name']
	  end
	  	  	  	  	
  end



  def test_index_tab_corrupt_or_without_go_to_risk_exposure
	  get :index , :project_id=>@project_id
	  assert_response :success, "not allowed??"
	
	  assigns_index_variables	
	  assert_equal assigns(:report_name), l(:risk_exposure_label)
	
	  get :index , :project_id=>@project_id , :tab=>'asdfasfdasdf'
	  assert_response :success, "not allowed??"
	
	  assigns_index_variables	
	  assert_equal assigns(:report_name), l(:risk_exposure_label)
  end

  private
  def assigns_index_variables
	  assert_not_nil assigns(:report_name)
	  assert_not_nil assigns(:rows)
  end

end

