require "rails_helper"

describe RegistrationPresenter do
  subject(:presenter) { RegistrationPresenter.new(registration) }
  let(:registration) { package.event.registrations.create(user: user, package: package, event: event) }
  let(:event) { FactoryGirl.create(:event) }
  let(:user) { FactoryGirl.create(:user) }
  let(:package) { FactoryGirl.create(:package) }
  let(:payment_method_configuration) { FactoryGirl.create(:payment_method_configuration, event: event) }

  def create_price(start_time, end_time, amount)
    package.package_prices.create(
      start_time: start_time,
      end_time: end_time,
      price: Price.new(amount: Money.new(amount))
    )
  end

  def pay(amount, date, state = :approved)
    registration.payments.create(amount: Money.new(amount), state: state, created_at: date, updated_at: date, payment_method_name: payment_method_configuration.payment_method_name)
  end

  context "with $100 earlybird pricing" do
    before do
      create_price("2015-01-01", "2015-02-01", 10000)
      create_price("2015-02-01", Time.current + 1.year, 20000)
    end

    context "when a $50 deposit was paid" do
      before do
        pay(5000, "2015-01-10")
      end

      it "has $100 total" do
        expect(presenter.total).to eq Money.new(10000)
      end

      it "has $50 paid" do
        expect(presenter.total_paid).to eq Money.new(5000)
      end

      it "has $50 outstanding" do
        expect(presenter.outstanding_balance).to eq Money.new(5000)
      end
    end

    context "when a $50 deposit was pledged but not approved" do
      before do
        pay(5000, "2015-01-10", :pending)
      end

      it "has $200 total" do
        expect(presenter.total).to eq Money.new(20000)
      end

      it "has $0 paid" do
        expect(presenter.total_paid).to be_zero
      end

      it "has $200 outstanding" do
        expect(presenter.outstanding_balance).to eq Money.new(20000)
      end
    end

    context "when $100 is paid in advance" do
      before do
        pay(10000, "2015-01-10")
      end

      it "has $100 total" do
        expect(presenter.total).to eq Money.new(10000)
      end

      it "has $100 paid" do
        expect(presenter.total_paid).to eq Money.new(10000)
      end

      it "has $0 outstanding" do
        expect(presenter.outstanding_balance).to be_zero
      end
    end

    context "with no payments at all" do
      it "has $200 total" do
        expect(presenter.total).to eq Money.new(20000)
      end

      it "has $0 paid" do
        expect(presenter.total_paid).to be_zero
      end

      it "has $200 outstanding" do
        expect(presenter.outstanding_balance).to eq Money.new(20000)
      end
    end

    context "with a payment during the second period" do
      before do
        pay(5000, "2015-02-10")
      end

      it "has $200 total" do
        expect(presenter.total).to eq Money.new(20000)
      end

      it "has $50 paid" do
        expect(presenter.total_paid).to eq Money.new(5000)
      end

      it "has $150 outstanding" do
        expect(presenter.outstanding_balance).to eq Money.new(15000)
      end
    end
  end
end
