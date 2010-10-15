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

#Represents a risk of a specific project. Its attributes are:
#* id: _identifier_
#* name: _required_
#* description
#* probability: {1..5}
#* impact: {1..5}
#* mitigation_status: {MITIGATION_STATUS_NONE=0, MITIGATION_STATUS_OPEN=1 , MITIGATION_STATUS_IN_PROGRESS=2, MITIGATION_STATUS_CLOSED=3}
#* mitigation: mitigation plan of the specific risk
#* contingency: contingency plan of the specific risk
#* risk_category_id: identifier of the associated risk_category. _required_
#* risk_id: identifier of the associated risk when the project risk comes from a well-known risk.
#* project_id: identifier of the project which belongs the risk. _required_
#* author_id: identifier of the user who creates the item. _required_
#* created_on: datetime. _required_
#* updated_on: datetime. _required_
class ProjectRisk < ActiveRecord::Base
  unloadable  # because of http://dev.rubyonrails.org/ticket/8246

  MITIGATION_STATUS_NONE = 0
  MITIGATION_STATUS_OPEN = 1
  MITIGATION_STATUS_IN_PROGRESS = 2
  MITIGATION_STATUS_CLOSED = 3

  belongs_to :project
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  belongs_to :risk_category
  belongs_to :risk

  has_and_belongs_to_many :issues

  validates_presence_of :project_id , :risk_category_id, :author_id ,:name , :message => "Missing elements"
  validates_numericality_of :mitigation_status, :greater_than_or_equal_to=> 0, :less_than_or_equal_to=> 3 , :message => "Invalid mitigation status"
  validates_numericality_of :probability, :greater_than_or_equal_to=> 1, :less_than_or_equal_to=> 5 , :message => "Invalid probability"
  validates_numericality_of :impact, :greater_than_or_equal_to=> 1, :less_than_or_equal_to=> 5 , :message => "Invalid impact"

  after_create :set_baseline_from_issue
  after_destroy :remove_baseline_issues

  #The initialize method is being neatly sidestepped when creating objects from the database
  def initialize(args = nil)
    super
    self.mitigation_status =  ProjectRisk::MITIGATION_STATUS_NONE if args.nil? || args[:mitigation_status].nil?
  end

  def exposure
    self.probability + self.impact
  end

  def set_baseline_from_issue
    self.reload
    if EnabledModule.find(:first,:conditions=>["project_id = ? and name = ?",self.project_id,"requirement_tool"]) != nil
      base= get_current_baseline(self.project_id)
      if base!= nil
        bi = BaselineRisks.new
        bi.risk_id = self.id
        bi.baseline_id = base.id
        bi.save
      end
      return true
    end
  end

  def remove_baseline_issues
    if EnabledModule.find(:first,:conditions=>["project_id = ? and name = ?",self.project_id,"requirement_tool"]) != nil
      BaselineRisks.destroy_all(['risk_id = (?)', self.id]) if self.id
    end
  end
end
