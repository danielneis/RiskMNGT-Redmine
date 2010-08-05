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

require "selenium"

###There is a rake task (risks:test:selenium:...) to prepare the environment to create the selenium tests.
### Precondition:
### --- application must be running in test mode: ruby script/server  webrick -e test -p 3000 -b localhost
### --- selenium must be running in port 4444: selenium --port 4444
### Problem with the test:
#### ---Fixtures are not working well.


### uncomment Test to run the Test via  ruby vendor/plugins/redmine_risks/test/unit/selenium_test.rb
class SeleniumTest #< Test::Unit::TestCase
	

  def setup	
    			Fixtures.create_fixtures(fixtures_dir, 'risk_categories')
			Fixtures.create_fixtures(fixtures_dir, 'risks')
			Fixtures.create_fixtures(fixtures_dir, 'projects')
			Fixtures.create_fixtures(fixtures_dir, 'users')
			Fixtures.create_fixtures(fixtures_dir, 'members')
			Fixtures.create_fixtures(fixtures_dir, 'roles')
			Fixtures.create_fixtures(fixtures_dir, 'enabled_modules')
			Fixtures.create_fixtures(fixtures_dir, 'project_risks')
			Fixtures.create_fixtures(fixtures_dir, 'project_incidents')
			Fixtures.create_fixtures(fixtures_dir, 'issues')
			Fixtures.create_fixtures(fixtures_dir, 'trackers')
			Fixtures.create_fixtures(fixtures_dir, 'projects_trackers')
			Fixtures.create_fixtures(fixtures_dir, 'issue_statuses')
			Fixtures.create_fixtures(fixtures_dir, 'issue_categories')
			Fixtures.create_fixtures(fixtures_dir, 'enumerations')	

    @user = User.first()
    @project= Project.find(1)

    selenium_port = 4444
    server = "http://localhost:3000/"
    @verification_errors = []
    if $selenium
      @selenium = $selenium
    else
      @selenium = Selenium::SeleniumDriver.new("localhost", selenium_port , "*firefox", server , 10000);
      @selenium.start
    end
    @selenium.set_context("test_delete_javascripts")
  end

  def teardown
     Fixtures.reset_cache   	
     @selenium.stop unless $selenium
     assert_equal [], @verification_errors	
  end


  def test_delete_javascripts    	  	
    	
    @selenium.open "/"
    @selenium.click "link=Sign in"
    @selenium.wait_for_page_to_load "30000"
    @selenium.type "username", "admin"
    @selenium.type "password", "admin"
    @selenium.click "login"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "link=Projects"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "link=eCookbook"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "//div[@id='main-menu']/ul/li[9]/a"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "link=Delete"
    assert /^\(memory shortage\) will be deleted\. Are you sure[\s\S]$/ =~ @selenium.get_confirmation
    @selenium.click "link=Incidents"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "link=Delete"
    assert /^\(memory shortage\) will be deleted\. Are you sure[\s\S]$/ =~ @selenium.get_confirmation
    @selenium.click "link=Risks"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "link=Delete"
    assert /^\(offer\) will be deleted\. Are you sure[\s\S]$/ =~ @selenium.get_confirmation
    @selenium.click "//a[@onclick=\"if (confirm('(To be deleted) will be deleted. Are you sure?')) { var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href;f.submit(); };return false;\"]"
    assert /^\(To be deleted\) will be deleted\. Are you sure[\s\S]$/ =~ @selenium.get_confirmation
    @selenium.click "//div[@id='content']/div[2]/ul/li[2]/a"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "//div[@id='content']/form/table/tbody/tr[2]/td[6]/a"
    assert /^\(name1\) will be deleted\. Are you sure[\s\S]$/ =~ @selenium.get_confirmation

  end


end

