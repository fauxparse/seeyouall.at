module ActionListHelper
  def action_list(options = {}, &block)
    options[:class] = "action-list #{options[:class]}".strip
    content_tag :ul, options, &block
  end

  def action_list_item(text, link, icon = nil, options = {})
    link = link_to(link) do
      concat icon(icon)
      concat content_tag(:span, text)
      concat yield if block_given?
    end

    content_tag :li do
      concat link
    end
  end
end
