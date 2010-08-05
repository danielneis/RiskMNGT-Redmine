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

class ProjectIncidentTest < Test::Unit::TestCase
			
  def setup
	
    plugin_create_fixtures( ['projects', 'issues','users','members','trackers','roles',	    		
			    'projects_trackers', 'issue_statuses','issue_categories','enumerations'] )

    @user = User.first()
    @project= Project.find(1)

  end	

  def teardown	  	
	Fixtures.reset_cache  		
  end		
		
  def test_insert
	
	  incident = ProjectIncident.new(:name=>'name', :project=>@project, :author=>@user)	  	
	  assert incident.save
	
  end


  def test_cannot_insert_without_presence_of
	
	  incident = ProjectIncident.new(:name=>'name', :project=>@project, :author=>@user)
	  incident.name = nil	
	  assert !incident.save
	
	  incident = ProjectIncident.new(:name=>'name', :project=>@project, :author=>@user)
	  incident.project = nil	
	  assert !incident.save
	
	  incident = ProjectIncident.new(:name=>'name', :project=>@project, :author=>@user)
	  incident.author = nil	
	  assert !incident.save	  	
  end


  def test_impact_field
	
	  incident = ProjectIncident.new(:name=>'name', :project=>@project, :author=>@user)
	
	  (1..5).each do |impact|		
		  incident.impact = impact		
		  assert incident.save
	  end
	
	  [-1,0,6,7,8,100].each do |impact|		
		  incident.impact = impact	
		  assert !incident.save
	  end
	
  end


  def test_correction_status_field
	
	  incident = ProjectIncident.new(:name=>'name', :project=>@project, :author=>@user)
	
	  (0..3).each do |status|		
		  incident.correction_status = status		
		  assert incident.save
	  end
	
	  [-1,-2, 4 ,6,7,8,100].each do |status|		
		  incident.correction_status = status	
		  assert !incident.save
	  end
	
  end


  def test_destroying_project_incident_will_not_destroy_belongs_relations
	
	  i = 1
	  project= Project.find(i)
	  user= User.find(i)

	  incident = ProjectIncident.new(:name=>'name', :project=>@project, :author=>@user)	  	
	  assert incident.save
	
	  ProjectIncident.destroy(incident)
	  	  	  	
	  assert_not_nil Project.find(i)
	  assert_not_nil User.find(i)	  	  	  	  	  	  	  	  	
  end


  def test_destroying_project_incident_will_not_destroy_belongs_relations
	
	  i = 1
	  project= Project.find(i)
	  user= User.find(i)

	  incident = ProjectIncident.new(:name=>'name', :project=>@project, :author=>@user)	  	
	  assert incident.save
	
	  ProjectIncident.destroy(incident)
	  	  	  	
	  assert_not_nil Project.find(i)
	  assert_not_nil User.find(i)	  	  	  	  	  	  	  	  	
  end


   def test_insert_with_related_issues
	  	  	
	  issue = Issue.new(:project_id => 1, :tracker_id => 1, :author_id => 3, :status_id => 1, :priority => Enumeration.get_values('IPRI').first, :subject => 'test_create', :description => 'IssueTest#test_create', :estimated_hours => '1:30')
	  assert issue.save, "issue could not be saved"
	
	  issue2 = Issue.new(:project_id => 1, :tracker_id => 1, :author_id => 3, :status_id => 1, :priority => Enumeration.get_values('IPRI').first, :subject => 'test_create', :description => 'IssueTest#test_create', :estimated_hours => '1:30')
	  assert issue2.save, "issue2 could not be saved"
        	  	  	
	
	  incident = ProjectIncident.new(:name=>'name', :project=>@project, :author=>@user)	
	  incident.issues << issue
	  incident.issues << issue2
	  assert incident.save, "prisk could not be saved"
	  assert incident.issues.size == 2 , "size of the collection different than the number of inserted elements"
	
	  incident = ProjectIncident.find(incident.id)
	  assert incident.issues.size == 2 , "size of the collection different than the number of inserted elements"	  	  	  	  	  	  	  	  	  	  	  	
  end

  def test_destroying_project_risk_will_not_destroy_related_issues
	
	  issue = Issue.new(:project_id => 1, :tracker_id => 1, :author_id => 3, :status_id => 1, :priority => Enumeration.get_values('IPRI').first, :subject => 'test_create', :description => 'IssueTest#test_create', :estimated_hours => '1:30')
	  assert issue.save, "issue could not be saved"
	
	  issue2 = Issue.new(:project_id => 1, :tracker_id => 1, :author_id => 3, :status_id => 1, :priority => Enumeration.get_values('IPRI').first, :subject => 'test_create', :description => 'IssueTest#test_create', :estimated_hours => '1:30')
	  assert issue2.save, "issue2 could not be saved"	  	
	  	  	  	
	  incident = ProjectIncident.new(:name=>'name', :project=>@project, :author=>@user)	
	  incident.issues << issue
	  incident.issues << issue2
	  assert incident.save, "prisk could not be saved"
	  assert incident.issues.size == 2 , "size of the collection different than the number of inserted elements"
	  	  	  	
	  assert ProjectIncident.destroy(incident.id)
	
	  assert_not_nil Issue.find(issue.id)
	  assert_not_nil Issue.find(issue2.id)	  	  	  	  	  	  	  	  	  	  	  	  	  	  	
  end


   def test_destroying_issues_will_not_destroy_related_project_risks
	  	  	  	  	
	  issue = Issue.new(:project_id => 1, :tracker_id => 1, :author_id => 3, :status_id => 1, :priority => Enumeration.get_values('IPRI').first, :subject => 'test_create', :description => 'IssueTest#test_create', :estimated_hours => '1:30')
	  assert issue.save, "issue could not be saved"
	
	  issue2 = Issue.new(:project_id => 1, :tracker_id => 1, :author_id => 3, :status_id => 1, :priority => Enumeration.get_values('IPRI').first, :subject => 'test_create', :description => 'IssueTest#test_create', :estimated_hours => '1:30')
	  assert issue2.save, "issue2 could not be saved"
	  	  	  	  	  	
	  incident = ProjectIncident.new(:name=>'name', :project=>@project, :author=>@user)	
	  incident.issues << issue
	  incident.issues << issue2
	  assert incident.save, "prisk could not be saved"
	  assert incident.issues.size == 2 , "size of the collection different than the number of inserted elements"
	
	  incident2 = ProjectIncident.new(:name=>'name', :project=>@project, :author=>@user)	
	  incident2.issues << issue
	  incident2.issues << issue2
	  assert incident2.save, "prisk could not be saved"
	  assert incident2.issues.size == 2 , "size of the collection different than the number of inserted elements"
	
	  issue_id = issue.id
	  issue2_id = issue2.id
	  	
	  assert Issue.destroy(issue.id)
	  assert Issue.destroy(issue2.id)
	
	
	  incident = ProjectIncident.find(incident.id)	  	
	  assert incident.issues.size == 0 , "issues didn't be removed from the project_risk"
	  	
	  incident2 = ProjectIncident.find(incident2.id)
	  assert incident2.issues.size == 0 , "issues didn't be removed from the project_risk"
	  	
  end


  def test_project_risk_cannot_have_a_repeated_issue
	
	  issue = Issue.first()
	  	  	  	  	  	  	
	  incident = ProjectIncident.new(:name=>'name', :project=>@project, :author=>@user)
	  incident.issues << issue
	  incident.issues << issue
	
	  assert_raise(ActiveRecord::StatementInvalid){
		  incident.save
	  }
	
	
	
	  incident.issues.clear
	  incident.issues << issue	
	  assert incident.save	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	
  end

end
