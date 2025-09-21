require 'rails_helper'
require 'faker'

RSpec.describe "API User" do
  before(:all) do
    @user = FactoryBot.create(:user, :admin)
  end

  let(:headers) {
    {
      "Content-Type" => "application/json",
      "Authorization" => "Basic #{Base64.strict_encode64("#{@user.username}:#{@user.password}")}"
    }
  }

  let(:create_user_params) do
    {
      username: Faker::Internet.unique.username(specifier: 5..8),
      password: "12345678",
    }
  end


  describe "POST /api/v1/user" do
    context "with valid credentials" do
      it "returns true" do
        post "/api/v1/user",
             params: JSON.dump(create_user_params),
             headers: headers

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["data"]).to eq(true)
      end
    end

    context "with invalid credentials" do
      it "returns 401 Unauthorized" do
        post "/api/v1/user",
             params: JSON.dump(create_user_params)

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with invalid parameters" do
      it "returns 422 Unprocessable Entity" do
        post "/api/v1/user",
             params: JSON.dump({}),
             headers: headers

        expect(response.status).to eq(422)
        json = JSON.parse(response.body)
        expect(json["error"]["code"]).to eq(422)
      end
    end
  end

  describe "POST /api/v1/user/me/follow" do
    let(:user_follow) { FactoryBot.create(:user) }
    context "with valid credentials" do
      it "returns true" do
        post "/api/v1/user/me/follow",
             params: JSON.dump({ "following_id" => user_follow.id }),
             headers: headers

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["data"]).to eq(true)
        expect(json["message"]).to eq("Success follow user")
      end
    end

    context "with invalid credentials" do
      it "returns 401 Unauthorized" do
        post "/api/v1/user/me/follow",
             params: JSON.dump({ "following_id" => user_follow.id })

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with invalid parameters" do
      it "returns 422 Unprocessable Entity" do
        post "/api/v1/user/me/follow",
             params: JSON.dump({}),
             headers: headers

        expect(response.status).to eq(422)
        json = JSON.parse(response.body)
        expect(json["error"]["code"]).to eq(422)
      end
    end
  end

  describe "DELETE /api/v1/user/me/unfollow" do
    let!(:user_follow) { FactoryBot.create(:user) }
    let!(:user_followings) { FactoryBot.create(:user_following, follower_id: @user.id, following_id: user_follow.id) }

    context "with valid credentials" do
      it "returns true" do
        delete "/api/v1/user/me/unfollow",
             params: JSON.dump({ "following_id" => user_follow.id }),
             headers: headers

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["data"]["user"]).to eq(nil)
        expect(json["message"]).to eq("Success unfollow user")
      end
    end

    context "with invalid credentials" do
      it "returns 401 Unauthorized" do
        delete "/api/v1/user/me/unfollow",
               params: JSON.dump({ "following_id" => user_follow.id })

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with invalid parameters" do
      it "returns 422 Unprocessable Entity" do
        delete "/api/v1/user/me/unfollow",
               params: JSON.dump({}),
               headers: headers

        expect(response.status).to eq(422)
        json = JSON.parse(response.body)
        expect(json["error"]["code"]).to eq(422)
      end
    end
  end

  describe "POST /api/v1/user/me/following-list" do
    let!(:user_follow) { FactoryBot.create(:user) }
    let!(:user_followings) { FactoryBot.create(:user_following, follower_id: @user.id, following_id: user_follow.id) }
    let(:page) { 1 }
    let(:per_page) { 10 }

    context "with valid credentials" do
      it "returns 200 with data following list" do
        post "/api/v1/user/me/following-list", headers: headers, params: JSON.dump({ page: page, per_page: per_page })
        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["data"]).to include("followings")
        expect(json["meta"]["pagination"]["page"]).to eq(page)
        expect(json["meta"]["pagination"]["per_page"]).to eq(per_page)
      end
    end

    context "with invalid credentials" do
      it "returns 401 Unauthorized" do
        post "/api/v1/user/me/following-list", params: JSON.dump({ page: page, per_page: per_page })

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /api/v1/user/me/follower-list" do
    let!(:user_follow) { FactoryBot.create(:user) }
    let!(:user_followings) { FactoryBot.create(:user_following, follower_id: user_follow.id, following_id: @user.id) }
    let(:page) { 1 }
    let(:per_page) { 10 }

    context "with valid credentials" do
      it "returns 200 with data follower list" do
        post "/api/v1/user/me/follower-list", headers: headers, params: JSON.dump({ page: page, per_page: per_page })
        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["data"]).to include("followers")
        expect(json["meta"]["pagination"]["page"]).to eq(page)
        expect(json["meta"]["pagination"]["per_page"]).to eq(per_page)
      end
    end

    context "with invalid credentials" do
      it "returns 401 Unauthorized" do
        post "/api/v1/user/me/follower-list", params: JSON.dump({ page: page, per_page: per_page })

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /api/v1/user/list-all" do
    let(:page) { 1 }
    let(:per_page) { 10 }

    context "with valid credentials" do
      it "returns 200 with data users list" do
        post "/api/v1/user/list-all", headers: headers, params: JSON.dump({ page: page, per_page: per_page })
        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["data"]).to include("users")
        expect(json["meta"]["pagination"]["page"]).to eq(page)
        expect(json["meta"]["pagination"]["per_page"]).to eq(per_page)
      end
    end

    context "with invalid credentials" do
      it "returns 401 Unauthorized" do
        post "/api/v1/user/list-all", params: JSON.dump({ page: page, per_page: per_page })

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end