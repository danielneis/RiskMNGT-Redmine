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

module ProjectRisksHelper
	
  #= mitigation_status_values
  #=== { 0 => "None", 1 => "Open", 2=>"In progress", 3=>"Closed" }
  #* @returns= hash whose keys are the mitigation status value and its values are the translated name of the specific mitigation status	
  def mitigation_status_values
	  h = {}	
	  h[ProjectRisk::MITIGATION_STATUS_NONE.to_i] = l(:none_label)
	  h[ProjectRisk::MITIGATION_STATUS_OPEN.to_i] = l(:open_label)
	  h[ProjectRisk::MITIGATION_STATUS_IN_PROGRESS.to_i] = l(:in_progress_label)
	  h[ProjectRisk::MITIGATION_STATUS_CLOSED.to_i] =  l(:closed_label)
	  h			
  end	


  #= mitigation_status_choices
  #* @returns= collection composed of labels of risk mitigation status and its respective values.
  def mitigation_status_choices  	  	
	  mitigation_status_values.invert.to_a.to_a.sort_by {|a,b| b}
  end


  #= status_label
  #* @param1= val: value of a risk mitigation status
  #* @returns= the risk mitigation status label
  def status_label(val)	
	  mitigation_status_values[val]	
  end

  #= level_values
  #=== { 1 => "Very low", 2 => "Low", 3=>"Medium", 4=>"High", 5=>"Very high" }
  #* @returns= hash whose keys are the level value and its values are the translated name of the specific level
  def level_values	
	 h = {}
	 h[1] = l(:very_low_label)
	 h[2] = l(:low_label)
	 h[3] = l(:medium_label)
	 h[4] = l(:high_label)
	 h[5] = l(:very_high_label)	
	 h	
  end

  #= status_choices
  #* @returns= collection composed of labels of levels (very high, high, medium, low, very low) and its respective values
  def level_choices
	level_values.invert.to_a.to_a.sort_by {|a,b| b}	
  end

  #= status_label
  #* @param1= val: value of a level. Range {1..5}
  #* @returns= the translated name of _val_
  def level_label(val)
	level_values[val]	
  end


  #= exposure_level_values
  #=== { 1 => "10%", 2 => "20%", 3=>"30%",........., 9=>"90%", 10=>"100%" }
  #* @returns= hash whose keys are the level value and its values are the translated name of the specific level
  def exposure_level_values	
	 h = {}
	 h[1] = '10%'
	 h[2] = '20%'
	 h[3] = '30%'
	 h[4] = '40%'
	 h[5] = '50%'
	 h[6] = '60%'
	 h[7] = '70%'
	 h[8] = '80%'
	 h[9] = '90%'
	 h[10] = '100%'
	 h	
  end

  #= exposure_level_values
  #* @returns= collection composed of labels of levels (very high, high, medium, low, very low)
  def exposure_level_choices
	exposure_level_values.invert.to_a.to_a.sort_by {|a,b| b}	
  end



end

