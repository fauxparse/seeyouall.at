class PaymentMethod
  class InternetBanking < PaymentMethod
    validates :account_name, :account_number, presence: { allow_blank: false }, if: :enabled?
    validates :account_number, format: { with: /\d{2}-\d{4}-\d{7}-\d{2,3}/ }, if: :enabled_and_has_account_number?

    def default_options
      super.merge("account_name" => nil, "account_number" => nil)
    end

    protected

    def enabled_and_has_account_number?
      enabled? && account_number?
    end
  end
end
