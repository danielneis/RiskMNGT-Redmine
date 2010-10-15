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

#Represents a system risk. Its attributes are:
#* id: _identifier_
#* name: _required_
#* description
#* status: {STATUS_INACTIVE=0, STATUS_ACTIVE=1}
#* mitigation: mitigation plan of the specific risk
#* status: contingency plan of the specific risk
#* risk_category_id: identifier of the associated risk_category. _required_
class Risk < ActiveRecord::Base
  STATUS_INACTIVE=0
  STATUS_ACTIVE=1

  belongs_to :risk_category

  validates_presence_of :risk_category_id, :name, :message => "Missing elements"
  validates_numericality_of :status, :greater_than_or_equal_to=> 0, :less_than_or_equal_to=> 2 , :message => "Invalid status"

  #The initialize method is being neatly sidestepped when creating objects from the database
  def initialize(args = nil)
    super
    self.status =  Risk::STATUS_ACTIVE if args.nil? || args[:status].nil?
  end
end
