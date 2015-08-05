require "rails_helper"

RSpec.describe TimetablesController, type: :controller do
  let(:event) { FactoryGirl.create(:event) }
  let(:user) { FactoryGirl.create(:user) }

  describe "GET #show" do
    it "returns http success" do
      get :show, event_id: event
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #edit" do
    before { event.administrators.create!(user: user) }

    context "when logged in" do
      include_context "logged in"

      it "returns http success" do
        get :edit, event_id: event
        expect(response).to have_http_status(:success)
      end
    end
  end
end
