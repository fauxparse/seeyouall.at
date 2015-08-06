require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  let(:event) { FactoryGirl.create(:event) }

  describe "GET #new" do
    it "returns http success" do
      get :new, event_id: event.slug
      expect(response).to have_http_status(:success)
    end
  end
end
