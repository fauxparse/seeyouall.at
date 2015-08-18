class CreatePayment < Struct.new(:payment, :payment_method)
  include Shout

  def call
    if payment.save
      publish!(*payment_method.when_created(payment))
    else
      publish!(:failure, payment)
    end
  end
end
