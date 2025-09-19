# frozen_string_literal: true

module UserRepository
  class ListAll < ::UserRepository::Base
    def get
      begin
        page = @params["page"] || 1
        per_page = @params["per_page"] || 10

        if @params["search_filter"].present?
          total = @model.where("username ILIKE ?", "%#{@params["search_filter"]}%").select(:id).count
          data = @model.where("username ILIKE ?", "%#{@params["search_filter"]}%").order("created_at #{(@params["order_direction"] || "desc").upcase}").page(page).per(per_page)
        else
          total = @model.all.select(:id).count
          data = @model.all.order("created_at #{(@params["order_direction"] || "desc").upcase}").page(page).per(per_page)
        end

        data = data.map do |user|
          {
            "id" => user.id,
            "username" => user.username,
          }
        end

        [
          true,
          {
            "data" => data,
            "meta" => handle_meta(page, per_page, total)
          },
          200
        ]
      rescue StandardError => e
        Rails.logger.info "UserRepository::ListAll ERROR: #{e.message}"
        [false, "Something went wrong", 500]
      end
    end

    def self.get(params)
      new(params).get
    end
  end
end
