class ListPayments
  def initialize(event, params = {})
    @event = event
    @params = params
  end

  def call
    sorted_scope.paginate(page: @params[:page], per_page: 25)
  end

  private

  def scope
    scope = Payment.for_event(@event)
  end

  def sorted_scope
    column, direction = (@params[:sort] || "").split(":")
    scope.order(Hash[column || :created_at, direction || :asc])
  end
end
