module Shout
  NoListenersError = Class.new(StandardError)

  def on(*events, &block)
    @_shout_listeners ||= {}

    events.each do |event|
      (@_shout_listeners[event] ||= []) << block
    end

    self
  end

  protected

  def publish(event, *args)
    (@_shout_listeners && @_shout_listeners[event] || []).each do |listener|
      listener.call(*args)
    end
  end

  def publish!(event, *args)
    raise NoListenersError, "No listeners are listening for event #{event}" if @_shout_listeners.nil? || @_shout_listeners[event].blank?

    publish(event, *args)
  end
end
