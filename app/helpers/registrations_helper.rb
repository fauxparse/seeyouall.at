module RegistrationsHelper
  def dollar_amount(money)
    money.currency.to_s + money_without_cents_and_with_symbol(money)
  end
end
