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

#Manages the project risk statistics of a specific project
class ProjectRiskStatisticsController < BaseRiskApplicationController
  unloadable

  before_filter :find_project
  before_filter :require_login
  before_filter :authorize

  helper :project_risks
  include ProjectRisksHelper
  include ProjectRiskStatisticsHelper
  include ProjectIncidentsHelper

  #Shows an specific report of project risks or incidents where the report is selected via params[:tab] {risk_impact||risk_probability||risk_status||risk_impact||risk_category||incident_status||incident_impact}
  #The report risk_exposure is configured by default and when params[:tab] is not specified or wrong
  def index
    case params[:tab]
      when "risk_impact"      then risk_impact
      when "risk_probability" then risk_probability
      when "risk_status"      then risk_status
      when "risk_category"    then risk_category
      when "incident_status"  then incident_status
      when "incident_impact"  then incident_impact
      else risk_exposure
    end
  end

  #Shows the report with the count of project risk per number of risk exposure.
  private
  def risk_exposure

    risks = ProjectRisk.find :all,
          :conditions=>["project_id = ?",@project.id]

    translations = exposure_level_choices


    data = Array.new
    (0..translations.size-1).each { |i|
      exposure_value = translations[i][1]
      h = {}
      h['value'] = exposure_value
      h['count'] = count_risks_with_exposure(risks, exposure_value)
      data << h
    } unless translations.nil?

    @report_name = l(:risk_exposure_label)
    @rows = compose_rows(data, translations )
  end

  def count_risks_with_exposure( risks, exposure )
    result = 0

    risks.each {|risk|
      result = result + 1 if risk.exposure == exposure
    } unless risks.nil?

    result
  end

  #Set the information of the report with the count of project risks in the specified project per risk impact
  def risk_impact

    sql = "select impact as value, count(id) as count
             from #{ProjectRisk.table_name}
            where project_id=#{@project.id}
         group by impact"

    data = ActiveRecord::Base.connection.select_all(sql)

    translations = level_choices

    @report_name = l(:risk_impact_label)
    @rows = compose_rows(data, translations )
  end

  #Set the information of the report with the count of project risks in the specified project per risk probability
  def risk_probability

    sql = "select  probability as value, count(id) as count
             from #{ProjectRisk.table_name}
            where project_id=#{@project.id}
         group by probability"

    data = ActiveRecord::Base.connection.select_all(sql)

    translations = level_choices

    @report_name = l(:field_probability)
    @rows = compose_rows(data, translations )
  end

  #Set the information of the report with the count of project risks in the specified project per risk category
  def risk_status

    sql = "select  mitigation_status as value, count(id) as count
             from #{ProjectRisk.table_name}
            where project_id=#{@project.id}
         group by mitigation_status"

    data = ActiveRecord::Base.connection.select_all(sql)

    translations = mitigation_status_choices

    @report_name = l(:field_mitigation_status)
    @rows = compose_rows(data, translations )
  end

  #Set the information of the report with the count of project risks in the specified project per risk category
  def risk_category
    sql = "select risk_category_id as value, count(id) as count
             from #{ProjectRisk.table_name}
            where project_id=#{@project.id}
         group by risk_category_id"

    data = ActiveRecord::Base.connection.select_all(sql)

    categories = RiskCategory.find :all, :conditions=>["status = ?", RiskCategory::STATUS_ACTIVE.to_i]

    translations = Array.new

    categories.each { |category|
      translations << [category.name,category.id]
    } unless categories.nil?

    @report_name = l(:risk_category_label)
    @rows = compose_rows(data, translations )
  end

  #Set the information of the report with the count of project incidents in the specified project per incident status
  def incident_status

    sql = "select correction_status as value, count(id) as count
             from #{ProjectIncident.table_name}
            where project_id=#{@project.id}
         group by correction_status"

    data = ActiveRecord::Base.connection.select_all(sql)

    translations = correction_status_choices

    @report_name = l(:field_correction_status)
    @rows = compose_rows(data, translations )

  end

  #Set the information of the report with the count of project incidents in the specified project per incident impact
  def incident_impact
    sql = "select impact as value, count(id) as count
             from #{ProjectIncident.table_name}
            where project_id=#{@project.id}
         group by impact"
    data = ActiveRecord::Base.connection.select_all(sql)

    translations = level_choices

    @report_name = l(:incident_impact_label)
    @rows = compose_rows(data, translations )
  end
end
