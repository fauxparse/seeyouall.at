class App.ItineraryEditor extends Spine.Controller
  events:
    "click .scheduled-activity": "showActivityDetails"

  showActivityDetails: (e) ->
    source = $(e.target).closest("article")
    new App.ActivityDetails({source})
      .on "hidden", -> source.removeClass("open")
    source.addClass("open")

class App.ActivityDetails extends App.Dialog
  events:
    "click header [rel=cancel]": "cancel"

  init: ->
    @el.hide().addClass("activity-details")
    super

  renderFooter: ->
    $("<footer>", class: "dialog-footer")
      .append($("<button>", rel: "book", text: I18n.t("itinerary.book")))
      .append($("<button>", rel: "cancel", text: I18n.t("dialog.cancel")))

  renderContent: ->
    # TODO make the header the right color
    @header = @source.find("header").clone()
      .append($("<div>", class: "header-color", style: "background: #{Color.named("orange").shade(500)}; opacity: 0;"))
      .append(@source.find("h4").clone())
      .append("<a href=\"#\" rel=\"cancel\"><i class=\"icon-cancel\"></i></a>")
    @content = super
      .prepend(@header)
      .append(@source.find(".description").clone())
      .on("scroll", @contentScrolled)

  show: ->
    offset = @source.offset()
    width = @source.outerWidth()
    height = @source.outerHeight()
    @wrapper
      .css(left: offset.left, top: offset.top, width: width, height: height)
      .closest(".dialog").show().end()
      .transition(left: 0, width: "100%", height: height * 2, duration: 250, easing: "easeOutCubic")
      .transition(top: 0, height: "100%", duration: 500, easing: "easeOutCubic")
    super

  hide: ->
    offset = @source.offset()
    width = @source.outerWidth()
    height = @source.outerHeight()
    @content.animate({ scrollTop: 0 }, 250)
    @wrapper
      .transition(left: offset.left, top: offset.top, width: width, height: height)
    super

  hidden: =>
    super

  contentScrolled: =>
    @_headerHeight ||= @header.outerHeight()
    @_headingHeight ||= @header.find("h4").outerHeight()
    top = @content.scrollTop()
    travel = @_headerHeight - @_headingHeight
    @header
      .find(".header-color").css(opacity: Math.min(1, top / travel)).end()
      .find("[rel=cancel]").css(y: Math.min(top, travel)).end()
      .css(y: Math.max(top - travel, 0))

$ ->
  $(".itinerary.editor").each -> new App.ItineraryEditor(el: this)
