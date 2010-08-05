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


# Load the normal Rails helper
require File.expand_path(File.dirname(__FILE__) + '/../../../../test/test_helper')

# Ensure that we are using the temporary fixture path
Engines::Testing.set_fixture_path


class Test::Unit::TestCase
	
  # Add more helper methods to be used by all tests here...

  def fixtures_dir	
	  File.expand_path(File.join(File.dirname(__FILE__), '/fixtures') )
  end

  def puts_info
	
	  categories = RiskCategory.find :all
	  puts "categories: #{categories.size}"
	
	  users = User.find :all
	  puts "users: #{users.size}"
	
	  projects = Project.find :all
	  puts "projects: #{projects.size}"
	
	  risks = Risk.find :all
	  puts "risks: #{risks.size}"
	  	  	
	  roles = Role.find :all
	  puts "roles #{roles.size}"
	
	  members = Member.find :all
	  puts "members #{members.size}"
	
  end

  def plugin_create_fixtures(table_names)
	
	  table_names.each do |tn|
		  Fixtures.create_fixtures(fixtures_dir, tn)
		  #puts "creating fixture: #{tn}"
	  end
	
  end


  def set_session_user_id(name)
	  unless name.nil?
		@request.session[:user_id] = 1 if name == 'admin'    	
    		@request.session[:user_id] = 2 if name ==  'manager'
    		@request.session[:user_id] = 3 if name ==  'developer'
	  end	  	
  end

  def test_order_of_bidimensional_array_for_select_in_view(a, asc)
	
	  assert_not_nil a	
	  assert  asc == true || asc == false
	
	  old_temp = asc ? -1 : 9999999
 	
	  (0..a.size-1).each do |i|
		  temp = a[i][1]
		
		  if asc
			  assert old_temp < temp
		  elsif
			  assert old_temp > temp
		  end
		
		  old_temp = temp		
	  end	  	
	
  end

  def test_hash_keys_include_in_range(h, range)
	  assert_not_nil h
	  assert_not_nil range
	
	  h.each_key {|key| assert range.include?(key) } 		  		   	  		
  end


  def test_index_permission_project_risk(project_id)	
    set_session_user_id('admin')
    get :index, :project_id=>project_id
    #assert_template 'project_incidents/index.rhtml'
    assert_response :success, "not allowed??"


    set_session_user_id('manager')
    get :index, :project_id=>project_id
    assert_response 403


    set_session_user_id('developer')
    get :index, :project_id=>project_id
    #assert_template 'project_incidents/index.rhtml'
    assert_response :success, "not allowed??"
  end

  def test_index_permission_project_risk_without_enabled_risk_project_module(project_id)
    set_session_user_id('admin')
    get :index, :project_id=>project_id
    assert_response 403


    set_session_user_id('manager')
    get :index, :project_id=>project_id
    assert_response 403

    set_session_user_id('developer')
    get :index, :project_id=>project_id
    assert_response 403
  end


  # it must have an input parameter, otherwise the tests are corrupt
  def test_index_permission_risk_admin(project_id)	
    set_session_user_id('admin')	
    get :index
    assert_response :success, "not allowed??"


    set_session_user_id('manager')
    get :index
    assert_response :success, "not allowed??"

    set_session_user_id('developer')
    get :index
    assert_response 403, "is allowed??"
  end
end
