module EventsHelper
  def current_event
    @current_event ||= try(:event).presence
  end

  def with_current_event
    yield current_event if current_event?
  end

  def event_header_link
    link_to(path_for_header_link, class: "logo") do
      concat content_tag(:span, t("header.title"), class: "see-you-all")
      concat content_tag(:span, t("header.title_short"), class: "see-you-all short")
      concat content_tag(:span, "@", class: "at")
      if current_event?
        concat content_tag(:span, event.name, class: "your-event-here has-event")
      else
        concat content_tag(:span, t("header.your_event_here"), class: "your-event-here")
      end
    end
  end

  def path_for_header_link
    if current_event?
      event_path(current_event)
    else
      new_event_path
    end
  end

  def current_event?
    current_event.present? && current_event.persisted?
  end

  def payment_methods
    @payment_methods ||= PaymentMethod.all_payment_methods.map do |method|
      event.payment_method_configurations.detect { |c| method === c.payment_method } ||
      event.payment_method_configurations.build(payment_method_name: method.name.demodulize.underscore)
    end.map(&:payment_method)
  end

  def homepage_event_registration_for_user(user)
    @registrations ||= if user
      current_user.registrations.where(user_id: @events.map(&:id)).map do |r|
        RegistrationPresenter.new(r)
      end
    else
      []
    end

    signed_in? ? @registrations.detect { |r| r.user_id == user.id } : nil
  end
end
