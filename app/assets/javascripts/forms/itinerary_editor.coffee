class App.ItineraryEditor extends Spine.Controller
  elements:
    ".package-limits": "limits"

  events:
    "click .scheduled-activity": "showActivityDetails"
    "click .scheduled-activity [rel=\"book\"]": "bookActivity"
    "click .scheduled-activity [rel=\"unbook\"]": "unbookActivity"

  init: ->
    @selected = (parseInt($(el).data("id")) for el in @$("[data-state*=\"selected\"]").get())

  showActivityDetails: (e) ->
    source = $(e.target).closest("article")
    new App.ActivityDetails({source})
      .on "hidden", -> source.removeClass("open")
    source.addClass("open")

  bookActivity: (e) ->
    e.stopPropagation()
    e.preventDefault()

    id = parseInt($(e.target).closest("article").data("id"))
    if @selected.indexOf(id) == -1
      @selected.push(id)
      @changed()

  unbookActivity: (e) ->
    e.stopPropagation()
    e.preventDefault()

    id = parseInt($(e.target).closest("article").data("id"))
    while (index = @selected.indexOf(id)) > -1
      @selected.splice(index, 1)
      @changed()

  changed: ->
    clearTimeout(@_checkTimer)
    @_checkTimer = setTimeout(@check, 100)

  check: =>
    options = $.extend {}, Spine.Ajax.defaults,
      url: "/events/#{@$("#event_id").val()}/itinerary/check"
      type: "post"
      contentType: "application/json"
      data: JSON.stringify(selections: @selected)
    $.ajax(options).done(@processCheckResult)

  processCheckResult: (data) =>
    @selected = []
    for own key, states of data.schedule
      key = parseInt(key)
      @selected.push(key) if states.indexOf("selected") > -1
      @$(".scheduled-activity[data-id=#{key}]").attr("data-state", states.join(" "))
    for own id, limits of data.limits
      @limits.find("[data-activity-type-id=#{id}]")
        .find(".bar").css(width: "#{limits.count * 100.0 / limits.limit}%").end()
        .find(".count").text(limits.count).end()

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
