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

  def placeholder_image(width: 320, height: 180, sequence:)
    sequence = sequence % 10 + 1 if sequence
    image_tag("http://lorempixel.com/#{width}/#{height}/cats/#{sequence || rand(1..10)}", alt: "Placeholder")
  end
end
