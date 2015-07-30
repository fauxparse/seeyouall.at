class TimePeriodValidator < ActiveModel::Validator
  def validate(record)
    return if record.start_time.blank? || record.end_time.blank?

    unless record.start_time < record.end_time
      record.errors.add(:end_time, "can't be before start time")
    end
  end
end