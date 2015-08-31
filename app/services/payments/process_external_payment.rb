class ProcessExternalPayment
  include ActiveModel::Validations
  
  attr_reader :params
  
  validate :payment_is_pending
  
  def initialize(params)
    @params = params
  end
  
  def call
    return false if !valid?
      
    if payment_was_successful?
      payment.approve!
    else
      payment.decline!
    end
  end
  
  def payment
    @payment ||= Payment.find_by(token: params[:id])
  end
  
  private
  
  def payment_is_pending
    errors.add(:base, "is not a pending payment!") if !payment.pending?
  end
  
  def payment_was_successful?
    params[:payment_status] == "Completed"
  end
end