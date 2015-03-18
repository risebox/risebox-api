class Demo::MetricsController < ApplicationController
  http_basic_authenticate_with name: 'dg', password: 'dg'

  def show
    @device = Risebox::Core::Device.find_by_key(params[:id])
    @metric = Risebox::Core::Metric.find_by_code params[:metric]
    @report_title = "Evolution de #{@metric.name}"
    @result = format_result @device.measures.for_metric(@metric.code).select([:taken_at, :value])
    @begin_at = 1.week.ago
  end
private
  def format_result result
    legend = {}
    result.select_values.each{ |col_name| legend[col_name] = col_name } #change col_name with human_readable_attribute
    format_result_in_json(legend, result)
  end

  def format_result_in_json legend, result
    {legend: legend, data: result}.to_json
  end
end