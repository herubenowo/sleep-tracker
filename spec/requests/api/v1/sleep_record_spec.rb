# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API SleepRecord' do
  before(:all) do
    @user = FactoryBot.create(:user)
  end

  let(:headers) {
    {
      "Content-Type" => "application/json",
      "Authorization" => "Basic #{Base64.strict_encode64("#{@user.username}:#{@user.password}")}"
    }
  }

  describe "POST /api/v1/sleep-records/clock-in" do
    context "with valid credentials" do
      it "returns 201 and user's sleep_records" do
        post "/api/v1/sleep-records/clock-in", headers: headers
        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Success clock in, have a nice sleep!")
        expect(json["data"]).to include("sleep_records")
      end
    end

    context "with invalid credentials" do
      it "returns 401 Unauthorized" do
        post "/api/v1/sleep-records/clock-in"

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /api/v1/slee-records/clock-out" do
    context "with valid credentials" do
      let(:sleep_records) { FactoryBot.create(:sleep_record, user_id: @user.id, started_at: Time.now) }
      it "returns 201" do
        post "/api/v1/sleep-records/clock-out", headers: headers
        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Success clock out, have a nice day!")
        expect(json["data"]).to eq(true)
      end
    end

    context "with invalid credentials" do
      it "returns 401" do
        post "/api/v1/sleep-records/clock-out"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "not clocked-in yet" do
      it "returns 409" do
        post "/api/v1/sleep-records/clock-out", headers: headers
        expect(response).to have_http_status(:conflict)

        json = JSON.parse(response.body)
        expect(json["error"]).to include("code", "errors")
      end
    end
  end

  describe "POST /api/v1/sleep-records/summary/me" do
    let(:page) { 1 }
    let(:per_page) { 10 }

    context "with valid credentials" do
      it "returns 200" do
        post "/api/v1/sleep-records/summary/me", headers: headers, params: JSON.dump({ "page" => page, "per_page" => per_page })
        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Success retrieve data")
        expect(json["data"]).to include("summary")
        expect(json["meta"]["pagination"]["page"]).to eq(page)
        expect(json["meta"]["pagination"]["per_page"]).to eq(per_page)
      end
    end

    context "with invalid credentials" do
      it "returns 401" do
        post "/api/v1/sleep-records/summary/me", params: JSON.dump({ "page" => page, "per_page" => per_page })
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /api/v1/sleep-records/summary/following" do
    let(:page) { 1 }
    let(:per_page) { 10 }

    context "with valid credentials" do
      it "returns 200" do
        post "/api/v1/sleep-records/summary/following", headers: headers, params: JSON.dump({ "page" => page, "per_page" => per_page })
        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Success retrieve data")
        expect(json["data"]).to include("summary")
        expect(json["meta"]["pagination"]["page"]).to eq(page)
        expect(json["meta"]["pagination"]["per_page"]).to eq(per_page)
      end
    end

    context "with invalid credentials" do
      it "returns 401" do
        post "/api/v1/sleep-records/summary/following", params: JSON.dump({ "page" => page, "per_page" => per_page })
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
