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

class CreateProjectRisks < ActiveRecord::Migration
  def self.up    	
	create_table :project_risks do |t|
	    t.column :name, :string, :null => false
	
	    t.column :description, :string
	
	    t.column :impact, :integer, :default => 1, :null => false
	
	    t.column :priority, :integer, :default => 1, :null => false
	
	    t.column :mitigation, :text
	
	    t.column :mitigation_status, :integer, :default => 0, :null => false
	
	    t.column :contingency, :text
	
	    t.column :contingency_responsable, :string	    	    	
	
	    t.belongs_to :project, :null => false
	
	    t.belongs_to :risk_category , :null => false
	
	    t.belongs_to :risk	

	    t.integer  :author_id ,  :null => false #, :default => 0
	
	    t.column :created_on, :timestamp
	
	    t.column :updated_on, :timestamp
    	end
	
	create_table :issues_project_risks , :id => false do |t|
		t.column "project_risk_id", :integer, :null=>false
		t.column "issue_id", :integer, :null=>false	
	end
	
	add_index "issues_project_risks", "project_risk_id"
        add_index "issues_project_risks", "issue_id"	
  end

  def self.down
    drop_table :project_risks
    drop_table :issues_project_risks
  end
end
