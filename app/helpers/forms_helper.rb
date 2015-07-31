module FormsHelper
  def composite_field(options = {})
    add_class(options, "composite-field")
    content_tag :div, options do
      concat yield if block_given?
      concat content_tag(:div, "", class: "composite-field-border")
    end
  end
end
