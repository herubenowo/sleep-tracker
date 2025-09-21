module Helpers
  def process_data(response)
    body = JSON.parse(response.body)
    # p body
    body
  end

  def http_post(url, params, headers)
    post url, params: params, headers: headers
    process_data(response)
  end

  def http_get(url, params, headers)
    get url, params: params, headers: headers
    process_data(response)
  end

  def http_put(url, params, headers)
    put url, params: params, headers: headers
    process_data(response)
  end

  def http_delete(url, headers)
    delete url, headers: headers
    process_data(response)
  end
end
