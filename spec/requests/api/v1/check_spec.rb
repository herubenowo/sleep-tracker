# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API Check' do
  before do
    @user = FactoryBot.create(:user)
  end

  let(:headers) {
    {
      "Content-Type" => "application/json",
      "Authorization" => "Basic #{Base64.strict_encode64("#{@user.username}:#{@user.password}")}"
    }
  }

  describe "GET / (home)" do
    context 'just hit root endpoint' do
      it 'succeeds' do
        get "/", headers: headers

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /anywhere (page not found)" do
    context 'just hit anywhere endpoint' do
      it 'returns 404' do
        get "/anywhere", headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /api/v1/check" do
    context "with valid credentials" do
      it "returns 201" do
        post "/api/v1/check", params: JSON.dump({}), headers: headers

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Success Check Connection")
        expect(json["data"]).to include("api_version", "db_connection", "redis_connection")
      end
    end
  end
end
