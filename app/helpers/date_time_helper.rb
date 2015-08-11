module DateTimeHelper
  def date_range(dates)
    interpolation = {
      d1: dates.first.day,
      m1: dates.first.strftime("%B"),
      y1: dates.first.strftime("%Y"),
      d2: dates.last.day,
      m2: dates.last.strftime("%B"),
      y2: dates.last.strftime("%Y")
    }
    translation = if dates.first.year == dates.last.year
      if dates.first.month == dates.last.month
        "date.range.same_month"
      else
        "date.range.different_month"
      end
    else
      "date.range.different_year"
    end
    t(translation, interpolation)
  end
end
