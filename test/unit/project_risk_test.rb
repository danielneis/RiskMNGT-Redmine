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

class ProjectRiskTest < Test::Unit::TestCase
			
  def setup
	
    plugin_create_fixtures( ['projects', 'risk_categories','risks',
	    		    'issues','users','members','trackers','roles',
			    'projects_trackers', 'issue_statuses','issue_categories','enumerations'] )

    @user = User.first()
    @risk= Risk.find(1)
    @category = @risk.risk_category
    @project= Project.find(1)
  end	

  def teardown	  	
	Fixtures.reset_cache  		
  end		
	
  def test_insert
	
	  prisk = ProjectRisk.new
	  prisk.name = 'hola hola'
	  prisk.risk_category = @category
	  prisk.risk = @risk
	  prisk.project = @project
	  prisk.author = @user
	
	  assert prisk.save
	
  end


  def test_cannot_insert_without_presence_of
	
	  prisk = ProjectRisk.new
	  #prisk.name = 'hola hola'	
	  prisk.risk_category = @category
	  prisk.project = @project
	  prisk.author = @user
	
	  assert !prisk.save, "test: name is null"
	
	  prisk = ProjectRisk.new
	  prisk.name = 'hola hola'	
	  #prisk.risk_category = @category 	
	  prisk.project = @project
	  prisk.author = @user
	
	  assert !prisk.save, "test: risk_category is null"
	
	  prisk = ProjectRisk.new
	  prisk.name = 'hola hola'
	  prisk.risk_category = @category
	  #prisk.project = @project
	  prisk.author = @user
	
	  assert !prisk.save, "test: project is null"
	
	  prisk = ProjectRisk.new
	  prisk.name = 'hola hola'
	  prisk.risk_category = @category
	  prisk.project = @project
	  #prisk.author = @user
	
	  assert !prisk.save, "user is null"
	
  end


  def test_cannot_insert_without_validates_numericality_of
	
	  prisk = ProjectRisk.new
	  prisk.name = 'hola hola'	
	  prisk.risk_category = @category
	  prisk.project = @project
	  prisk.impact = 6
	
	  assert !prisk.save, "impact invalid"
	
	  prisk = ProjectRisk.new
	  prisk.name = 'hola hola'	
	  prisk.risk_category = @category
	  prisk.project = @project
	  prisk.probability = 6
	
	  assert !prisk.save, "probability invalid"
	
	
	  prisk = ProjectRisk.new
	  prisk.name = 'hola hola'	
	  prisk.risk_category = @category
	  prisk.project = @project
	  prisk.mitigation_status = 4
	
	  assert !prisk.save, "mitigation_status invalid"
	  	  	  	
  end


  def test_cannot_insert_without_validates_numericality_of
	
	  prisk = ProjectRisk.new(:name=>'hola hola', :risk_category=>@category, :risk=>@risk, :project=>@project, :author=>@user)
	  prisk.impact = 6
	
	  assert !prisk.save, "impact invalid"
	
	  prisk = ProjectRisk.new(:name=>'hola hola', :risk_category=>@category, :risk=>@risk, :project=>@project, :author=>@user)
	  prisk.probability = 6
	
	  assert !prisk.save, "probability invalid"
	
	
	  prisk = ProjectRisk.new(:name=>'hola hola', :risk_category=>@category, :risk=>@risk, :project=>@project, :author=>@user)	
	  prisk.mitigation_status = 4
	
	  assert !prisk.save, "mitigation_status invalid"
	  	  	  	
  end


  def test_destroying_project_risk_will_not_destroy_belongs_relations
	
	  i = 1
	  risk=Risk.find(i)
	  category = RiskCategory.find(i)
	  project= Project.find(i)
	  user= User.find(i)

	  prisk = ProjectRisk.new(:name=>'hola hola', :risk_category=>category, :risk=>risk, :project=>project, :author=>user)	
	  assert prisk.save
	
	  ProjectRisk.destroy(prisk)
	  	  	
	  assert_not_nil Risk.find(i)
	  assert_not_nil RiskCategory.find(i)
	  assert_not_nil Project.find(i)
	  assert_not_nil User.find(i)
	  	  	  	  	  	  	  	  	
  end


  def test_insert_with_related_issues
	  	  	
	  issue = Issue.new(:project_id => 1, :tracker_id => 1, :author_id => 3, :status_id => 1, :priority => Enumeration.get_values('IPRI').first, :subject => 'test_create', :description => 'IssueTest#test_create', :estimated_hours => '1:30')
	  assert issue.save, "issue could not be saved"
	
	  issue2 = Issue.new(:project_id => 1, :tracker_id => 1, :author_id => 3, :status_id => 1, :priority => Enumeration.get_values('IPRI').first, :subject => 'test_create', :description => 'IssueTest#test_create', :estimated_hours => '1:30')
	  assert issue2.save, "issue2 could not be saved"


	  #issues = Issue.find(:all)	
	  #assert_not_nil issues	
	  #count = issues.nil? ? 0 : issues.size
	  #assert count > 0
	
	  #issue = Issue.first
	  #assert_not_nil issue	
	  #issue.subject = 'changing'
	  #assert issue.save, "issue could not be saved"	
	  #issue = Issue.find(issue.id)
	  	  	
	
	  prisk = ProjectRisk.new(:name=>'hola hola', :risk_category=>@category, :risk=>@risk, :project=>@project , :author=>@user)
	  prisk.issues << issue
	  prisk.issues << issue2
	  assert prisk.save, "prisk could not be saved"
	  assert prisk.issues.size == 2 , "size of the collection different than the number of inserted elements"
	
	  prisk = ProjectRisk.find(prisk.id)
	  assert prisk.issues.size == 2 , "size of the collection different than the number of inserted elements"	  	  	  	  	  	  	  	  	  	  	  	
  end


  def test_destroying_project_risk_will_not_destroy_related_issues
	
	  issue = Issue.new(:project_id => 1, :tracker_id => 1, :author_id => 3, :status_id => 1, :priority => Enumeration.get_values('IPRI').first, :subject => 'test_create', :description => 'IssueTest#test_create', :estimated_hours => '1:30')
	  assert issue.save, "issue could not be saved"
	
	  issue2 = Issue.new(:project_id => 1, :tracker_id => 1, :author_id => 3, :status_id => 1, :priority => Enumeration.get_values('IPRI').first, :subject => 'test_create', :description => 'IssueTest#test_create', :estimated_hours => '1:30')
	  assert issue2.save, "issue2 could not be saved"	  	
	  	  	  	
	  prisk = ProjectRisk.new(:name=>'hola hola', :risk_category=>@category, :risk=>@risk, :project=>@project , :author=>@user)
	  prisk.issues << issue
	  prisk.issues << issue2
	  assert prisk.save, "prisk could not be saved"
	  assert prisk.issues.size == 2 , "size of the collection different than the number of inserted elements"
	  	  	  	
	  assert ProjectRisk.destroy(prisk.id)
	
	  assert_not_nil Issue.find(issue.id)
	  assert_not_nil Issue.find(issue2.id)	  	  	  	  	  	  	  	  	  	  	  	  	  	  	
  end


  def test_destroying_issues_will_not_destroy_related_project_risks
	  	  	  	  	
	  issue = Issue.new(:project_id => 1, :tracker_id => 1, :author_id => 3, :status_id => 1, :priority => Enumeration.get_values('IPRI').first, :subject => 'test_create', :description => 'IssueTest#test_create', :estimated_hours => '1:30')
	  assert issue.save, "issue could not be saved"
	
	  issue2 = Issue.new(:project_id => 1, :tracker_id => 1, :author_id => 3, :status_id => 1, :priority => Enumeration.get_values('IPRI').first, :subject => 'test_create', :description => 'IssueTest#test_create', :estimated_hours => '1:30')
	  assert issue2.save, "issue2 could not be saved"
	  	  	  	  	  	
	  prisk = ProjectRisk.new(:name=>'hola hola', :risk_category=>@category, :risk=>@risk, :project=>@project , :author=>@user)
	  prisk.issues << issue
	  prisk.issues << issue2
	  assert prisk.save, "prisk could not be saved"
	  assert prisk.issues.size == 2 , "size of the collection different than the number of inserted elements"
	
	  prisk2 = ProjectRisk.new(:name=>'hola hola', :risk_category=>@category, :risk=>@risk, :project=>@project , :author=>@user)
	  prisk2.issues << issue
	  prisk2.issues << issue2
	  assert prisk2.save, "prisk could not be saved"
	  assert prisk2.issues.size == 2 , "size of the collection different than the number of inserted elements"
	
	  issue_id = issue.id
	  issue2_id = issue2.id
	  	
	  assert Issue.destroy(issue.id)
	  assert Issue.destroy(issue2.id)
	
	
	  prisk = ProjectRisk.find(prisk.id)	  	
	  assert prisk.issues.size == 0 , "issues didn't be removed from the project_risk"
	  	
	  prisk2 = ProjectRisk.find(prisk2.id)
	  assert prisk2.issues.size == 0 , "issues didn't be removed from the project_risk"
	  	
  end

  def test_created_on_updated_on
	prisk = ProjectRisk.new(:name=>'hola hola', :risk_category=>@category, :risk=>@risk, :project=>@project, :author=>@user)
	assert_nil prisk.created_on
	assert_nil prisk.updated_on
	assert prisk.save
	
	
	prisk = ProjectRisk.find(prisk.id)
	assert_not_nil prisk.created_on
	assert_not_nil prisk.updated_on
	
	assert_equal prisk.created_on , prisk.updated_on
	
	
	sleep 1
	prisk.name='changing'
	assert prisk.save
	
	prisk = ProjectRisk.find(prisk.id)
	assert_not_equal prisk.created_on , prisk.updated_on
										
  end


  def test_project_risk_cannot_have_a_repeated_issue
	
	  issue = Issue.first()
	  	  	  	  	  	  	
	  prisk = ProjectRisk.new(:name=>'hola hola', :risk_category=>@category, :risk=>@risk, :project=>@project , :author=>@user)
	  prisk.issues << issue
	  prisk.issues << issue
	
	  assert_raise(ActiveRecord::StatementInvalid){
		  prisk.save
	  }
	
	
	
	  prisk.issues.clear
	  prisk.issues << issue	
	  assert prisk.save	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	
  end


end
