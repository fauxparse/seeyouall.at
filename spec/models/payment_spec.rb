require 'rails_helper'

RSpec.describe Payment, type: :model do
  subject(:payment) { Payment.new }

  it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }

  describe "#state" do
    %w(pending approved declined refunded).each do |state|
      it "can be #{state}" do
        expect { payment.state = state }.not_to raise_error
      end
    end

    it "does not accept any old nonsense" do
      expect { payment.state = "indeterminate" }.to raise_error(ArgumentError)
    end
  end
end
