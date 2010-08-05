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

class RisksControllerTest < ActionController::TestCase
	
  def setup	  	  	
    plugin_create_fixtures( ['risk_categories','risks','projects','users','members','roles'] )
    #puts_info

    @controller = RisksController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    User.current = nil
    set_session_user_id('admin')
  end

  def teardown	  	
	Fixtures.reset_cache  		
  end	


  def test_index_permissions	
	   test_index_permission_risk_admin(nil)
  end




  def test_create_new_created_item
    list = Risk.find :all
    count_before = list.size

    post :create, :risk => {:name => 'A new one',
	    	            :risk_category_id=>1}

    assert_redirected_to 'risks/index'

    list = Risk.find :all
    count = list.size

    assert_equal count, count_before +1
  end




  def test_update_updated_item

    new_name = 'ooooooooooooooo'
    new_description = 'mmmmmmmoo'
    id = 1

    post :update,	:id => id,
    			:risk => { :name => new_name,
	    			       :description => new_description }

    assert_redirected_to 'risks/index'

    risk = Risk.find(id)

    assert_not_nil risk
    assert_equal risk.name , new_name
    assert_equal risk.description , new_description

  end


  def test_delete_works_only_through_post	
    [:get,:put,:delete].each do |http_method|
	    send http_method, :delete, :id=>"1"	
	    assert_response 400, "allows delete method no post request??"
    end

    list = Risk.find :all
    count_before = list.size

    assert_not_nil Risk.find("1"), 'corrupt test data'

    post :delete, :id => 1
    assert_redirected_to 'risks/index'

    list = Risk.find :all
    assert_equal count_before -1 , list.size

  end

    def test_preview
	
    contingency='that is an example to test'
    mitigation='thdddddddddddd'

    get :preview, :risk => {:mitigation => mitigation, :contingency=>contingency}, :opt=>'mitigation'    	
    #assert_template 'common/_preview'
    assert_equal assigns(:text) , mitigation

    get :preview, :risk => {:mitigation => mitigation, :contingency=>contingency}, :opt=>'contingency'    	
    #assert_template 'common/_preview'

    assert_equal assigns(:text) , contingency
	
  end


  def test_delete_cannot_with_associated_project_risk
    	
    project = Project.find(1)
    category = RiskCategory.first
    user = User.first


    risk=Risk.new
    risk.name = 'pruebaderiesgo'
    risk.risk_category = category
    risk.save


    prisk = ProjectRisk.new
    prisk.name = 'hola hola'
    prisk.risk_category = category
    prisk.risk = risk
    prisk.project = project
    prisk.author = user
    prisk.save



    risk = Risk.find(risk.id)
    assert_not_nil risk, 'corrupt test data'

    list = Risk.find :all
    count_before = list.size

    post :delete, :id => risk.id
    assert_redirected_to 'risks/index'

    list = Risk.find :all
    assert_equal count_before  , list.size
    assert_not_nil Risk.find(risk.id)


  end


end

