class AllocationPresenter < SimpleDelegator
  alias_method :allocation, :__getobj__

  def description
    if maximum.blank?
      I18n.t("allocations.unlimited", type: plural)
    else
      "#{maximum} #{maximum == 1 ? name : plural}"
    end
  end

  def activity_type
    ActivityTypePresenter.new(allocation.activity_type)
  end

  def unlimited?
    !maximum.present?
  end

  delegate :name, :plural, to: :activity_type
end
