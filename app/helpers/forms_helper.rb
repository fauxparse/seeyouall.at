module FormsHelper
  def composite_field(options = {})
    add_class(options, "composite-field")
    content_tag :div, options do
      concat yield if block_given?
      concat content_tag(:div, "", class: "composite-field-border")
    end
  end

  def floating_label_field(form, field, options = {})
    add_class(options, "floating-label field")
    add_class(options, "has-errors") if form.object.errors.include?(field)
    content_tag :section, options do
      concat yield if block_given?
      concat form.label(field)
      form.object.errors.full_messages_for(field).each do |msg|
        concat content_tag(:small, msg, class: "error-message")
      end
    end
  end
end
