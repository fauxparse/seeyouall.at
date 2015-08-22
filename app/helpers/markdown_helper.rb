module MarkdownHelper
  def markdown(text)
    return "" if text.blank?
    renderer.render(text).html_safe
  end

  protected

  def renderer
    @markdown ||= Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      autolink: true
    )
  end
end
