require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let (:event) { FactoryGirl.create(:event) }
  let (:user) { FactoryGirl.create(:user) }
  let (:event_params) { EventSerializer.new(EventPresenter.new(FactoryGirl.build(:event))).attributes }

  def log_in_as(user)
    user.confirm
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "has a list of events" do
      get :index
      expect(assigns(:events)).not_to be_nil
    end
  end

  describe "GET #show" do
    context "for an existing event" do
      before do
        get :show, id: event.to_param
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "assigns the event" do
        expect(assigns(:event)).to be_an_instance_of(EventPresenter)
      end
    end

    context "for a non-existent event" do
      it "throws an error" do
        expect { get :show, id: "missing" }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "GET #new" do
    context "when logged in" do
      before do
        log_in_as(user)
      end

      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end

      it "has a list of events" do
        get :new
        expect(assigns(:event)).to be_an_instance_of(EventPresenter)
      end
    end

    context "when not logged in" do
      before do
        get :new
      end

      it "redirects to login page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST #create" do
    context "when logged in" do
      before do
        log_in_as(user)
      end

      it "creates an event" do
        expect { post :create, event: event_params }
          .to change { Event.count }.by(1)
      end
    end

    context "when not logged in" do
      it "does not create the event" do
        expect { post :create, event: event_params }
          .not_to change { Event.count }
      end

      it "redirects to login page" do
        post :create, event: event_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #edit" do
    context "for an existing event" do
      before do
        event.administrators.create!(user: user)
      end

      context "when logged in" do
        before do
          log_in_as(user)
          get :edit, id: event.to_param
        end

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it "assigns the event" do
          expect(assigns(:event)).to be_an_instance_of(EventPresenter)
        end
      end

      context "when not logged in" do
        before do
          get :edit, id: event.to_param
        end

        it "redirects to login page" do
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end

    context "for a non-existent event" do
      context "when logged in" do
        before do
          log_in_as(user)
        end

        it "throws an error" do
          expect { get :edit, id: "poops" }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "when not logged in" do
        before do
          get :edit, id: "missing"
        end

        it "redirects to login page" do
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end
  end

  describe "PUT #update" do
    let(:updated_params) { EventSerializer.new(EventPresenter.new(event)).attributes.merge(name: "Updated") }

    context "when not logged in" do
      it "redirects to login page" do
        put :update, id: event.to_param, event: updated_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when logged in" do
      before do
        log_in_as(user)
      end

      it "denies access" do
        expect { put :update, id: event.to_param, event: updated_params }
          .to raise_error(CanCan::AccessDenied)
      end

      context "as an event admin" do
        before do
          event.administrators.create!(user: user)
        end

        it "redirects to the event index" do
          put :update, id: event.to_param, event: updated_params
          expect(response).to redirect_to(edit_event_path(event))
        end

        it "updates the event" do
          put :update, id: event.to_param, event: updated_params
          expect(event.reload.name).to eq("Updated")
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context "when not logged in" do
      it "redirects to login page" do
        delete :destroy, id: event.to_param
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when logged in" do
      before do
        log_in_as(user)
      end

      it "denies access" do
        expect { delete :destroy, id: event.to_param }
          .to raise_error(CanCan::AccessDenied)
      end

      context "as an event admin" do
        before do
          event.administrators.create!(user: user)
        end

        it "redirects to the event index" do
          delete :destroy, id: event.to_param
          expect(response).to redirect_to(events_path)
        end
      end
    end
  end

  describe "POST #check" do
    before do
      log_in_as(user)
    end

    it "returns http success" do
      post :check, event: event_params
      expect(response).to have_http_status(:success)
    end
  end
end
