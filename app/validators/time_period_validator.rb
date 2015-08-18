class TimePeriodValidator < ActiveModel::Validator
  def validate(record)
    return if record.start_time.blank? || record.end_time.blank?

    if record.end_time < record.start_time
      record.errors.add(:end_time, :before_start)
    end
  end
end
