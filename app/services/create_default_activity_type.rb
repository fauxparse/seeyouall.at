class CreateDefaultActivityType < Struct.new(:event)
  def call
    event.activity_types.create(name: "activity")
  end
end
