shared_examples "a secure resource" do |method|
  let(:user) { FactoryGirl.create(:user).tap(&:confirm) }
  let(:request_method) { :get }
  let(:params) { {} }

  context "when logged in" do
    include_context "logged in"

    before { send request_method, method, params }

    it { is_expected.to respond_with(:success) }
  end

  context "when not logged in" do
    before { send request_method, method, params }

    it { is_expected.to redirect_to(new_user_session_path) }
  end
end

shared_context "logged in" do
  let(:user) { FactoryGirl.create(:user).tap(&:confirm) }

  before { log_in_as(user) }

  def log_in_as(user)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end
end
