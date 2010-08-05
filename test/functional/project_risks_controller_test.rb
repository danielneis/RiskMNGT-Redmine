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

class ProjectRisksControllerTest < ActionController::TestCase
	
  def setup	  	  	
    plugin_create_fixtures( ['risk_categories','risks','projects','users',
		  'members' , 'roles' , 'enabled_modules','project_risks','issues' , 'trackers',
		  'projects_trackers', 'issue_statuses','issue_categories','enumerations'] )
    #puts_info

    @controller = ProjectRisksController.new
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


  def test_index_pagination_filter_items_per_page
	
    category = RiskCategory.first
    project = Project.find(@project_id)

    max = 125
	
    for i in (1..max)
	    prisk = ProjectRisk.new(:name=>'ho', :risk_category=>category, :project=>project, :author=>User.current)	  	
	    prisk.save
    end

    risks = ProjectRisk.find :all
    assert max < risks.size

    [25,50,100].each do |items_per_page|
	  get :index, :project_id=>@project_id, :per_page=> items_per_page
	  assert_equal assigns["risks"].size , items_per_page
    end

  end


  def test_index_filter_by_project
    	
    list = ProjectRisk.find :all,
    				:conditions=>[ "project_id=? " , @project_id]
    count_before = list.size
    assert count_before > 0
    assert count_before < 25

    post :index, :project_id=>@project_id

    assert_not_nil assigns(:risks)
    assert_equal assigns(:risks).size , count_before
	    			                                                	
  end


  def test_retrieve_cannot_access_a_project_risk_via_identifier_of_a_different_project

    project_risk_id=6 # project_id = 3

    post :retrieve , :id=>project_risk_id,  :project_id=>@project_id

    assert_response 404

    project_risk_id=1 # project_id = 3
    post :retrieve , :id=>project_risk_id,  :project_id=>@project_id

    assert_response :success, "not allowed??"    	    			
  end


  def test_delete_works_only_through_post	
    [:get,:put,:delete].each do |http_method|
	    send http_method, :delete, :project_id=>@project_id, :id=>1	
	    assert_response 400, "allows delete method no post request??"
    end

    list =  ProjectRisk.find :all
    count_before = list.size

    assert_not_nil ProjectRisk.find("1"), 'corrupt test data'

    post :delete, :project_id=>@project_id , :id => 1
    assert_redirected_to 'project_risks/index'

    list =  ProjectRisk.find :all

    assert_equal list.size + 1, count_before
  end


  def test_issues_new
    id = 1
    risk = ProjectRisk.find(id)
    init_issues = 0
    assert_equal  risk.issues.size , init_issues

    # can be inserted
    post :issues_new, :issue => {:id => 1}, :project_id=>@project_id, :id=>id
    assert_redirected_to '/project_risks/issues_index'

    risk = ProjectRisk.find(id)
    assert_equal risk.issues.size , init_issues+1

    # cannot be inserted twice
    post :issues_new, :issue => {:id => 1}, :project_id=>@project_id, :id=>id
    assert_redirected_to '/project_risks/issues_index'

    risk = ProjectRisk.find(id)
    assert_equal risk.issues.size , init_issues+1

    # cannot be inserted a non-existing issue
    post :issues_new, :issue => {:id => 999999}, :project_id=>@project_id, :id=>id
    assert_redirected_to '/project_risks/issues_index'

    risk = ProjectRisk.find(id)
    assert_equal risk.issues.size , init_issues+1

  end


  def test_issues_delete
    id = 1
    risk = ProjectRisk.find(id)

    [1,2,3].each do |issue_id|
	    risk.issues << Issue.find(issue_id)
    end

    assert risk.save
    assert risk.issues.size , 3

    post :issues_delete , :issue_id =>1 , :project_id=>@project_id , :id=>id
    assert_redirected_to '/project_risks/issues_index'

    risk = ProjectRisk.find(id)
    assert risk.issues.size , 2

    post :issues_delete , :issue_id =>2 , :project_id=>@project_id , :id=>id
    assert_redirected_to '/project_risks/issues_index'

    risk = ProjectRisk.find(id)
    assert risk.issues.size , 1

    # again an already deleted issue
    post :issues_delete , :issue_id =>2 , :project_id=>@project_id , :id=>id
    assert_redirected_to '/project_risks/issues_index'

    risk = ProjectRisk.find(id)
    assert risk.issues.size , 1

  end


  def test_preview
	
    contingency='that is an example to test'
    mitigation='thdddddddddddd'

    get :preview, :project_risk => {:mitigation => mitigation, :contingency=>contingency}, :opt=>'mitigation'    	
    #assert_template 'common/_preview'
    assert_equal assigns(:text) , mitigation

    get :preview, :project_risk => {:mitigation => mitigation, :contingency=>contingency}, :opt=>'contingency'    	
    #assert_template 'common/_preview'

    assert_equal assigns(:text) , contingency
	
  end


  def test_update_selectable_risks
	
    id = 1
    post :update_selectable_risks , :project_id=>@project_id , :project_risk_id=>id  ,:project_risk_risk_category_id=>1
    #assert_template 'project_risks/_select_risk'
    assert_response :success, "not allowed??"
    assert_not_nil assigns(:select_risks)

  end

end

