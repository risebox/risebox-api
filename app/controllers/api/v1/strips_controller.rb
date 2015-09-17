class API::V1::StripsController < API::V1::DeviceSecuredController
  skip_before_filter :verify_authenticity_token

  def create
    launched = JobRunner.run(ComputeStripTest, params[:model], @device.key, params[:upload_key], parse_date(params[:tested_at]))
    api_response [launched, nil]
  end

  def show
    svc = rescuer Risebox::Query::Strip.new(@device)
    res = svc.show(params[:id])
    api_response res
  end

private

  def parse_date date
    return nil if date.nil?
    tested_at = nil
    begin
      tested_at = DateTime.parse(date)
    rescue ArgumentError
      puts "DateTime is invalid : will be nil"
    end
    tested_at
  end

end