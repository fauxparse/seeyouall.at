class EventDetails extends Spine.Controller
  elements:
    "> header": "header"
    ".body > aside": "sidebar"

  init: ->
    $(document).on("scroll", @scrolled)
    $(window).on("resize", @resized)
    setTimeout(@scrolled, 0)

  scrolled: =>
    @_header_height ?= @header.outerHeight()
    @_heading_height ?= @header.find("h1").outerHeight()
    @_page_width ?= $("main").outerWidth()
    travel = @_header_height - @_heading_height
    top = $("body").scrollTop()
    @header
      .find(".header-color").css(opacity: Math.min(1, top / travel)).end()
      .css(y: Math.max(top - travel, 0))
    @sidebar.css(y: @_page_width >= 640 && Math.max(top - travel, 0) || 0)

  resized: =>
    delete @_header_height
    delete @_heading_height
    delete @_page_width
    @scrolled()

$ ->
  $(".event-details").each -> new EventDetails(el: this)
