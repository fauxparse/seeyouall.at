class CreateDefaultPackage < Struct.new(:event)
  def call
    event.packages.create(name: "Standard", allocations: allocations)
  end

  protected

  def allocations
    event.activity_types.map { |type| Allocation.new(activity_type: type) }
  end
end
