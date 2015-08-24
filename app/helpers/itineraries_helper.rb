module ItinerariesHelper
  def time_slot_header(time_slot)
    content_tag :h4 do
      concat content_tag(:span, "#{l(time_slot.start_time, format: :time_only)} – #{l(time_slot.end_time, format: :time_only)}", class: "times")
      types = time_slot.activity_types.map do |t|
        time_slot.activities_of_type(t).count == 1 ? t.name : t.plural
      end
      concat content_tag(:span, "#{types.to_sentence.capitalize}", class: "activity-types")
    end
  end

  def placeholder_image(width: 320, height: 180, sequence:)
    sequence = sequence % 10 + 1 if sequence
    image_tag(placeholder_image_url(width:width, height: height, sequence: sequence), alt: "Placeholder")
  end

  def placeholder_image_url(width: 320, height: 180, sequence:)
    "http://lorempixel.com/#{width}/#{height}/cats/#{sequence || rand(1..10)}"
  end
end
