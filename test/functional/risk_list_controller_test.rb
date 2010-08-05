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

class RiskListControllerTest < ActionController::TestCase
	
  def setup
	
    plugin_create_fixtures( ['risk_categories','risks','projects','users',
		  'members' , 'roles' , 'enabled_modules','project_risks','issues' , 'trackers',
		  'projects_trackers', 'issue_statuses','issue_categories','enumerations'] )

    @controller = RiskListController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @project_id = 1
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


  def test_list
	
    get :index, :risk=>{:risk_category_id=>1}, :project_id=>@project_id
    assert_template 'risk_list/index.rhtml'

    assert_not_nil assigns(:select_categories)

    # category not found....
    get :index, :risk=>{:risk_category_id=>100}, :project_id=>@project_id
    assert_response 404

  end

end

