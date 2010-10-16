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

require 'redmine'

Redmine::Plugin.register :redmine_risks do
  name 'Redmine risks plugin'
  author 'Isotrol S.A. && Daniel Neis Araujo'
  description 'Risk plugin'
  version '1.0.1'


  menu :project_menu, :risks,
       {:controller => 'project_risks', :action => 'index'},
       :caption => :risks_label, :param => :project_id

  menu :top_menu,
       :risk_admin,
       {:controller => 'risk_categories', :action => 'index'},
       :if => Proc.new{User.current.allowed_to?( { :controller => 'risk_categories', :action => 'index' } , nil, :global => true)},
       :caption => :risks_label

  project_module :risks do
     permission :project_risks,
                :project_risks => [:index, :new, :create ,:show, :update, :destroy, :issues_index, :issues_new , :issues_delete],
                :project_incidents => [:index, :create ,:show, :update, :destroy, :issues_index, :issues_new , :issues_delete],
                :risk_list=> [:index],
                :project_risk_statistics=> [:index]
  end

  permission :risk_admin_permission,
             :risk_categories => [:index, :create ,:show, :update, :delete],
             :risks => [:index, :create ,:show, :update, :delete]
end
