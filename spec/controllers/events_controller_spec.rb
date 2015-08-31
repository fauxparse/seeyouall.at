require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:event) { FactoryGirl.create(:event) }
  let(:user) { FactoryGirl.create(:user) }
  let(:event_params) { EventSerializer.new(EventPresenter.new(FactoryGirl.build(:event))).attributes }

  describe "GET #index" do
    before { get(:index) }
    it { is_expected.to respond_with(:success) }
  end

  describe "GET #show" do
    context "for an existing event" do
      before { get(:show, id: event.to_param) }

      it { is_expected.to respond_with(:success) }
      it { is_expected.to assign(:event).as(EventPresenter) }
    end

    context "for a non-existent event" do
      it "throws an error" do
        expect { get :show, id: "missing" }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "GET #new" do
    # it_behaves_like "a secure resource", :new
  end

  describe "POST #create" do
    context "when logged in" do
      include_context "logged in"

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
      before { event.administrators.create!(user: user) }

      it_behaves_like("a secure resource", :edit) do
        let(:params) { { id: event.to_param } }
      end

      context "when logged in" do
        include_context "logged in"

        before { get :edit, id: event.to_param }

        it { is_expected.to assign(:event).as(EventPresenter) }
      end
    end

    context "for a non-existent event" do
      context "when logged in" do
        include_context "logged in"

        it "throws an error" do
          expect { get :edit, id: "poops" }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe "PUT #update" do
    let(:updated_params) { EventSerializer.new(EventPresenter.new(event)).attributes.merge(name: "Updated") }

    context "when logged in" do
      include_context "logged in"

      context "as a regular user" do
        it "denies access" do
          expect {put :update, id: event.to_param, event: updated_params }
            .to raise_error(CanCan::AccessDenied)
        end

        it "does not update the event" do
          expect(event.reload.name).to eq("Tri-Wizard Tournament")
        end
      end

      context "as an event admin" do
        before do
          event.administrators.create!(user: user)
          put :update, id: event.to_param, event: updated_params
        end

        it { is_expected.to redirect_to(edit_event_path(event))}

        it "updates the event" do
          expect(event.reload.name).to eq("Updated")
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context "when logged in" do
      include_context "logged in"

      context "as a regular user" do
        it "denies access" do
          expect { delete :destroy, id: event.to_param }
            .to raise_error(CanCan::AccessDenied)
        end
      end

      context "as an event admin" do
        before { event.administrators.create!(user: user) }

        it "redirects to the event index" do
          delete :destroy, id: event.to_param
          expect(response).to redirect_to(events_path)
        end
      end
    end
  end

  describe "POST #check" do
    include_context "logged in"

    before { post :check, event: event_params }

    it { is_expected.to respond_with(:success) }
  end
end
