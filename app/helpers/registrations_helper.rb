module RegistrationsHelper
  def dollar_amount(money, include_currency = true)
    content_tag :span, class: "money" do
      concat content_tag(:abbr, money.currency) if include_currency
      concat money_without_cents_and_with_symbol(money)
    end
  end
end
