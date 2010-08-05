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

require File.dirname(__FILE__) + '/../../test_helper'



class ProjectRisksHelperTest < Test::Unit::TestCase

  include ProjectRisksHelper
    				
  	 		
  def test_mitigation_status_values_correct_range
	  h = mitigation_status_values
	  range = (0..3)
	  	  	
	  test_hash_keys_include_in_range( h , range )	
  end

  def test_mitigation_status_choices_order_asc
	
	  a = mitigation_status_choices
	  asc = true
	  	  		
	  test_order_of_bidimensional_array_for_select_in_view( a , asc )
	    	
  end

  def test_level_values_correct_range
	  	  	  	
	  test_hash_keys_include_in_range( level_values , (1..5) )	
  end


  def test_level_choices_order_asc
	  	  	  	  		
	  test_order_of_bidimensional_array_for_select_in_view( level_choices  , true )	    	
  end


end
