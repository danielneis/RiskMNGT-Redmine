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

module ProjectRiskStatisticsHelper
	
	
	#= status_choices
	#== create an array of Row class where Row.name is the translated value, Row.value the identifier of the translator item
	#== which must be the same than item['value'] where item is an item of the array _data_. Row.count is equal to item['count'] when item['value'] is equal to translation key, otherwise 0.
	#* @param1= data: array of hash element whose element has count and value keys. [{ "value" => 1, "count" => 2 } , { "value" => 2, "count" => 1 }].
	#* @param2= translator: Array of translation items for each data.item[value]. [ [1,'translation1'],[2,'translation2] ]
	#* @returns= array of Row with an item for each translator item.
	def compose_rows(data,translator)
		
		result =  Array.new
		
		(0..translator.size-1).each { |i|						
		#translator.each_pair { |key, value|
			value = translator[i][0]
			key = translator[i][1]
			
			row = Row.new
			row.name = value
			row.value= key
			
			item = get_item_of_data_whose_value_equal_key(key,  data)
			
			row.count = item.nil? ? 0 : item['count']
									
			result << row
			
		} unless translator.nil?
				
		result
	end
	

	#= get_item_of_data_whose_value_equal_key
	#== return the first item from the array _data_ where item['value'] is equal to _key_, otherwise returns nil
	#* @param1= key: string.
	#* @param2= data: array of hash element whose element has count and value keys. [{ "value" => 1, "count" => 2 } , { "value" => 2, "count" => 1 }].
	#* @returns= the first item from the array _data_ where item['value'] is equal to _key_, otherwise returns nil 	
	private
	def get_item_of_data_whose_value_equal_key( key,  data)
		result = nil
		
		data.each { |item|
			result = item if item['value'].to_i == key								
		}unless data.nil?
		
		result	
	end
	
	
end

