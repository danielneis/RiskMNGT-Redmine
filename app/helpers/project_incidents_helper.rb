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

module ProjectIncidentsHelper
	
  #= correction_status_values
  #=== { 0 => "None", 1 => "Resolved", 2=>"Not resolved", 3=>"In progress" }
  #* @returns= hash whose keys are the correction status value and its values are the translated name of the specific correction status	
  def correction_status_values
	  h = {}	
	  h[ProjectIncident::CORRECTION_STATUS_NONE.to_i] = l(:none_label)
	  h[ProjectIncident::CORRECTION_STATUS_RESOLVED.to_i] = l(:resolved_label)
	  h[ProjectIncident::CORRECTION_STATUS_NOT_RESOLVED.to_i] = l(:not_resolved_label)
	  h[ ProjectIncident::CORRECTION_STATUS_IN_PROGRESS.to_i] =  l(:in_progress_label)
	  h			
  end	

	
  #= correction_status_choices
  #* @returns= collection composed of labels of incident correctionstatus and its respective values.
  def correction_status_choices
	  correction_status_values.invert.to_a.sort_by {|a,b| b}			
  end


  #= correction_status_label
  #* @param1= val: value of a incident correction status
  #* @returns= the incident correction status label
  def correction_status_label(val)
	  correction_status_values[val]	  	
  end


end
