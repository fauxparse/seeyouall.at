require "rails_helper"

RSpec.describe PaymentMethodConfiguration, type: :model do
  subject(:configuration) { FactoryGirl.create(:payment_method_configuration) }

  describe "#options" do
    it "is serialised" do
      expect(configuration.reload.options["account_name"]).to eq("H Potter")
    end
  end

  describe "#payment_method" do
    it "returns a subclass of PaymentMethod" do
      expect(configuration.payment_method).to be_an_instance_of(PaymentMethod::InternetBanking)
    end

    it "gets options from the stored configuration" do
      expect(configuration.payment_method.account_name).to eq("H Potter")
    end

    it "stores options on the configuration" do
      configuration.payment_method.account_name = "H Granger"
      expect(configuration.options["account_name"]).to eq("H Granger")
    end

    it "reloads correctly" do
      configuration.payment_method.account_name = "H Granger"
      configuration.save
      expect(configuration.reload.payment_method.account_name).to eq("H Granger")
    end
  end
end
