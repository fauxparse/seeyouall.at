module ItinerariesHelper
  def time_slot_header(time_slot)
    content_tag :h4 do
      concat content_tag(:span, "#{l(time_slot.start_time, format: :time_only)} – #{l(time_slot.end_time, format: :time_only)}")
      types = time_slot.activity_types.map do |t|
        time_slot.activities_of_type(t).count == 1 ? t.name : t.plural
      end
      concat content_tag(:span, "#{types.to_sentence.capitalize}")
    end
  end
end
