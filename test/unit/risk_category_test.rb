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

class RiskCategoryTest < Test::Unit::TestCase



  def test_can_modify_status_on_new_creation	

    status = RiskCategory::STATUS_INACTIVE

    category = RiskCategory.new(:status => status, :name=>'pepecano')
    assert category.save

    category = RiskCategory.find(category.id)
    assert category.status.to_i == status



    status = RiskCategory::STATUS_ACTIVE

    category = RiskCategory.new(:status => status, :name=>'pepecano')
    assert category.save

    category = RiskCategory.find(category.id)
    assert category.status.to_i == status

  end

  def test_cannot_insert_with_invalid_null_values	
    category=RiskCategory.new
    category.description='description'


    assert !category.save
  end

  def test_cannot_insert_with_invalid_status	
    category=RiskCategory.new
    category.name='asdfsafd'
    category.description='description'
    category.status = 5

    assert !category.save
  end


  def test_insert	
    category=RiskCategory.new
    category.name='asdfsafd'
    category.description='description'

    assert category.save
  end



  def test_hasmany_risks	
    category=RiskCategory.new
    category.name='category'
    category.save

    risk=Risk.new
    risk.name='asdfsafd'
    risk.risk_category = category        		
    risk.save

    risk2=Risk.new
    risk2.name='asdfsafd'
    risk2.risk_category = category        		
    risk2.save

    c = RiskCategory.find(category.id) #it is not neccesary

    assert_equal c.risks.count , 2 , "hasmany relation does not work"
  end


  def test_risks_will_be_destroyed_when_category_is_destroyed	
    category=RiskCategory.new
    category.name='category'
    category.save

    risk=Risk.new
    risk.name='asdfsafd'
    risk.risk_category = category        		
    risk.save

    risk2=Risk.new
    risk2.name='asdfsafd'
    risk2.risk_category = category        		
    risk2.save

    assert_equal category.risks.count , 2 , "hasmany relation does not work"

    risk_id = risk.id
    risk2_id = risk2.id
    category_id = category.id

    assert_not_nil( RiskCategory.first( :conditions => [ "id = ?", category_id ] ) , "category not found in db..." )

    assert RiskCategory.destroy(category_id)

    assert_nil( RiskCategory.first( :conditions => [ "id = ?", category_id ] ) , "category was not removed..." )


    assert_nil( Risk.first( :conditions => [ "id = ?", risk_id ] )  )
    assert_nil( Risk.first( :conditions => [ "id = ?", risk2_id ] )  )
  end







end
