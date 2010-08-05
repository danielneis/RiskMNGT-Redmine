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


class RiskCategoriesControllerTest < ActionController::TestCase
		
  def setup	  	  	
    plugin_create_fixtures( ['risk_categories','risks','projects','users','members','roles'] )

    @controller = RiskCategoriesController.new
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

  def test_retrieve_find_id
    get :retrieve , :id => "1"
    assert_response :success, "id not found"

    get :retrieve , :id => "54654654"
    assert_response 404, "id found???"
  end



  def test_create_view_create
    get :create
    assert_template 'create'
  end

  def test_create_new_created_item
    list = RiskCategory.find :all
    count_before = list.size

    post :create, :category => {:name => 'A new one',
	    			:description => 'description'}

    assert_redirected_to 'risk_categories/index'

    list = RiskCategory.find :all
    count = list.size

    assert_equal count, count_before +1
  end


  def test_update_view_update
    get :update, :id => 1
    assert_template 'update'
  end


  def test_update_updated_item

    new_name = 'ooooooooooooooo'
    new_description = 'mmmmmmmoo'
    id = 1

    post :update,	:id => id,
    			:category => { :name => new_name,
	    			       :description => new_description }

    assert_redirected_to 'risk_categories/index'

    category = RiskCategory.find(id)

    assert_not_nil category
    assert_equal category.name , new_name
    assert_equal category.description , new_description

  end


  def test_delete_works_only_through_post	
    [:get,:put,:delete].each do |http_method|
	    send http_method, :delete, :id=>"4"	
	    assert_response 400, "allows delete method no post request??"
    end

    list = RiskCategory.find :all
    count_before = list.size

    assert_not_nil RiskCategory.find("5"), 'corrupt test data'

    post :delete, :id => 5
    assert_redirected_to 'risk_categories/index'

  end


  def test_delete
    list = RiskCategory.find :all
    count_before = list.size

    # a category without assigned risks/project_risks can be deleted
    id = 5
    category = RiskCategory.find(id)
    assert category.risks.size == 0

    post :delete, :id => id
    assert_redirected_to 'risk_categories/index'

    list = RiskCategory.find :all
    count = list.size

    assert_equal count_before -1, count

  end


  def test_delete_cannot_with_associated_risks
    	
    project = Project.find(1)
    user = User.first


    category = RiskCategory.new
    category.name = 'pruebaderiesgo'
    category.save


    risk=Risk.new
    risk.name = 'pruebaderiesgo'
    risk.risk_category = category
    risk.save


    category = RiskCategory.find(category.id)
    assert_not_nil category, 'corrupt test data'

    list = RiskCategory.find :all
    count_before = list.size

    post :delete, :id => category.id
    assert_redirected_to 'risk_categories/index'


    list = RiskCategory.find :all
    assert_equal count_before , list.size
    assert_not_nil RiskCategory.find(category.id)	
	
  end

  def test_delete_cannot_with_associated_project_risk
    	
    project = Project.find(1)
    user = User.first


    category = RiskCategory.new
    category.name = 'pruebaderiesgo'
    category.save


    prisk = ProjectRisk.new
    prisk.name = 'hola hola'
    prisk.risk_category = category
    prisk.project = project
    prisk.author = user
    prisk.save



    category = RiskCategory.find(category.id)
    assert_not_nil category, 'corrupt test data'

    list = RiskCategory.find :all
    count_before = list.size

    post :delete, :id => category.id
    assert_redirected_to 'risk_categories/index'


    list = RiskCategory.find :all
    assert_equal count_before , list.size
    assert_not_nil RiskCategory.find(category.id)


  end




end

