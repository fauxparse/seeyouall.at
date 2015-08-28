class RegistrationMailer < ApplicationMailer
  def payment_approval_email(payment)
    load_registration_details(payment)
    @amount = MoneyPresenter.new(payment.amount)
    @outstanding = MoneyPresenter.new(@registration.outstanding_balance)
    
    mail(
      to: @user.email,
      subject: I18n.t("emails.payments.approved.subject", event: @event)
    )
  end
  
  private
  
  def load_registration_details(payment)
    @registration = RegistrationPresenter.new(payment.registration)
    @user = UserPresenter.new(@registration.user)
    @event = EventPresenter.new(@registration.event)
  end
end
