class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :amount, :state, :payment_method_name
  
  delegate :name, :email, to: :user
  
  def amount
    MoneyPresenter.new(object.amount).to_s
  end
  
  def registration
    object.registration
  end
  
  def user
    registration.user
  end
end
