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

module RisksHelper
	
  #= risk_status_values
  #=== { 0 => "Inactive", 1 => "Active" }
  #* @returns= hash whose keys are the risk status value and its values are the translated name of the specific category status 	
  def risk_status_values
	  h = {}
	  h[Risk::STATUS_INACTIVE.to_i]=l(:inactive_label)
	  h[Risk::STATUS_ACTIVE.to_i]=l(:active_label)	   	
	  h
  end	

  #= risk_status_choices
  #* @returns= collection of Risk status labels and its respective values to be used on a html select
  def risk_status_choices
	  risk_status_values.invert.to_a.to_a.sort_by {|a,b| a}	
  end


  #= risk_status_label
  #* @param1= val: value of a risk category status
  #* @returns= the Risk status label
  def risk_status_label(val)
	  risk_status_values[val]	
  end


end
