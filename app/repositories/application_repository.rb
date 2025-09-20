class ApplicationRepository
  def initialize(params)
    raise "params is invalid" if params.class != Hash && params.class != Hashie::Mash

    @params = params
    @model = nil
  end

  def handle_meta(page, per_page, total)
    {
      "pagination" => {
        "page" => page,
        "per_page" => per_page,
        "total" => total
      }
    }
  end
end
