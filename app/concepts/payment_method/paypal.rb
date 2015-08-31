class PaymentMethod
  class Paypal < PaymentMethod
    validates :email,
      presence: { allow_blank: false }

    validates :email,
      format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ },
      if: [:enabled?, :email?]

    def default_options
      super.merge("email" => nil)
    end

    def when_created(payment)
      [:redirect, paypal_url(payment)]
    end

    protected

    def paypal_url(payment)
      url = return_url(payment)
      values = {
        business: email,
        cmd: "_xclick",
        upload: 1,
        return: url + "#{payment.id}",
        notify_url: url + "#{payment.token}/process",
        invoice: payment.id,
        amount: payment.amount,
        item_name: payment.registration.event.name,
        currency_code: payment.amount.currency.iso_code
      }
      "#{ENV['PAYPAL_HOST']}/cgi-bin/webscr?" + values.to_query
    end

    def return_url(payment)
      "#{ENV['APP_HOST']}/events/#{payment.registration.event.slug}/payments/"
    end
  end
end
