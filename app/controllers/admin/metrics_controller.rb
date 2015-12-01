class Admin::MetricsController < Admin::BaseController

  def show
    @device = Risebox::Core::Device.find_by_key(params[:id])
    @metric = Risebox::Core::Metric.find_by_code params[:metric]
    @report_title = "Evolution de #{@metric.name}"
    @begin_at = params[:begin_at].present? ? params[:begin_at] : 1.hour.ago.beginning_of_hour
    @result = format_result @device.raw_measures.for_metric(@metric.code).only_data.chronologic.since(@begin_at)
    @time_frames = time_frames
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

  def time_frames
    [
      ['1 heure',   1.hour.ago.beginning_of_hour],
      ['1 jour',    1.day.ago.beginning_of_hour],
      ['1 semaine', 1.week.ago.beginning_of_hour]
    ]
  end
end