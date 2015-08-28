class MoneyPresenter < SimpleDelegator
  include MoneyRails::ActionViewExtension
  
  alias_method :amount, :__getobj__
  
  def to_s
    "#{amount.currency} #{money_without_cents_and_with_symbol(amount)}"
  end
end