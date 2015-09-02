class ListParticipants
  PER_PAGE = 1000 # TODO: pagination
  
  def initialize(event, params = {})
    @event = event
    @params = params
  end

  def call
    sorted_scope.page(@params[:page]).per_page(PER_PAGE)
  end

  private

  def scope
    scope = Registration
      .includes(:user).references(:users)
      .with_package
      .for_event(@event)
  end

  def sorted_scope
    column, direction = (@params[:sort] || "").split(":")
    scope.order("#{column || "users.name"} #{direction || :asc}")
  end
end
