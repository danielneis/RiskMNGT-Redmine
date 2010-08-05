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

require File.expand_path(File.dirname(__FILE__) + '/../../test/test_helper')


# rake command to record the trace of the selenium tests
# initiliaze the database with the fixtures of the plugin
# execute ---> 1º purge 2º load
# 3º create the test cases with selenium
namespace :risks do  
  namespace :test do
  	ENV["RAILS_ENV"] ||= "test"
	namespace :selenium do  
  	  	
			
		task :load do
													
		        puts "before must be purged, execute command rake risks:test:selenium:clean"
			fixtures_dir = File.expand_path(File.join(File.dirname(__FILE__), '/../../test/fixtures') )
			
			
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
			
		end
		
		task :clean do
			 puts "before must be purged, execute command rake risks:test:selenium:purge"
			 # unknown error cannot be executed via.....
			 Rake::Task['db:migrate'].invoke
			 puts "db_migrate"
			 Rake::Task['db:migrate_plugins'].invoke
			 puts "db_migrate_plugins"		
		end
		
		task :purge do			
			Rake::Task['db:test:purge'].invoke
			puts "purge"
		end
		
		
		
			
	end  	  
  end
end
