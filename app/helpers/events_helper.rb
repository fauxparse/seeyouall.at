module EventsHelper
  def with_current_event
    yield event if respond_to?(:event)
  end
end
