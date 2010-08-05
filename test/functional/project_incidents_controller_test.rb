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

class ProjectIncidentsControllerTest < ActionController::TestCase
	
  def setup	  	  	
	  plugin_create_fixtures( ['project_incidents','projects','users',
		  'members' , 'roles' , 'enabled_modules','project_risks','issues' , 'trackers',
		  'projects_trackers', 'issue_statuses','issue_categories','enumerations'] )

    @controller = ProjectIncidentsController.new
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


  def test_index_filters
    	
    correction_status = 1
    impact = 1

    conditionsStm = [ "project_id=? AND correction_status=? AND impact=?" , @project_id,  correction_status , impact ]

    list = ProjectIncident.find :all,
    				:conditions=>conditionsStm
    count_before = list.size
    assert count_before > 0
    assert count_before < 25

    post :index, :incident => {:correction_status => correction_status, :impact=>impact} , :project_id=>@project_id

    assert_not_nil assigns(:incidents)
    assert_equal assigns(:incidents).size , count_before
	    			                                                	
  end


  def test_index_filters_params_empty
    		      	
    conditionsStm = [ "project_id=? " , @project_id ]	
    list = ProjectIncident.find :all,
    				:conditions=>conditionsStm	

    count_before = list.size
    assert count_before > 0
    assert count_before < 25

    post :index, :incident => {:correction_status => '', :impact=>''} , :project_id=>@project_id

    assert_not_nil assigns(:incidents)
    assert_equal assigns(:incidents).size , count_before
	    			                                                	
  end

  def test_preview
    correction='that is an example to test'

    get :preview, :incident => {:correction => correction}    	
    assert_template 'common/_preview'

    assert_not_nil assigns(:text)
    assert_equal assigns(:text) , correction
	
  end

  def test_create
         	
    list = ProjectIncident.find :all
    count_before = list.size

    name = 'hola hola'
    post :create, :incident => {:name => name} , :project_id=>@project_id
	    			

    assert_redirected_to 'project_incidents/index'

    list = ProjectIncident.find :all
    assert_equal list.size, count_before +1

  end


  def test_create_required_fields_not_sent
    	
    list = ProjectIncident.find :all
    count_before = list.size

    name = nil
    post :create, :incident => {:name => name} , :project_id=>@project_id
	    			

    #assert_template 'project_incidents/create'
    assert_response :success, "not allowed??"

    list = ProjectIncident.find :all
    assert_equal list.size, count_before
	
  end


  def test_delete_works_only_through_post

    id = 1	
    [:get,:put,:delete].each do |http_method|
	    send http_method, :delete, :project_id=>@project_id, :id=>id	
	    assert_response 400, "allows delete method no post request??"
    end

    list =  ProjectIncident.find :all
    count_before = list.size

    assert_not_nil ProjectIncident.find( id ), 'corrupt test data'

    post :delete, :project_id=>@project_id , :id => id
    assert_redirected_to 'project_incidents/index'

    list =  ProjectIncident.find :all

    assert_equal list.size + 1  , count_before
  end


   def test_delete_cannot_access_a_project_risk_via_identifier_of_a_different_project
    id=6 # project_id = 3

    post :delete , :id=>id,  :project_id=>@project_id

    assert_response 404                    	    			
  end



end

