class Risebox::Api::SimpleResponse
  def initialize result, params={}
    @response = {result: result}
  end

  def response_headers
    {}
  end

  def response_body
    @response
  end
end