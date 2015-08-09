class App.ItineraryEditor extends Spine.Controller
  events:
    "click .scheduled-activity": "showActivityDetails"

  showActivityDetails: (e) ->
    source = $(e.target).closest("article")
    new App.ActivityDetails({source})
      .on "hidden", -> source.removeClass("open")
    source.addClass("open")

class App.ActivityDetails extends App.Dialog
  init: ->
    @el.hide().addClass("activity-details")
    super
    @container.prepend(@source.find("header").clone())

  show: ->
    offset = @source.offset()
    width = @source.outerWidth()
    height = @source.outerHeight()
    @wrapper
      .css(left: offset.left, top: offset.top, width: width, height: height)
      .closest(".dialog").show().end()
      .transition(left: 0, width: "100%", height: height * 2, duration: 500, easing: "easeOutCubic")
      .transition(top: 0, height: "100%", duration: 500, easing: "easeOutCubic")
    super

  hide: ->
    offset = @source.offset()
    width = @source.outerWidth()
    height = @source.outerHeight()
    @wrapper
      .transition(left: offset.left, top: offset.top, width: width, height: height)
    super

  hidden: =>
    console.log "boop"
    super

$ ->
  $(".itinerary.editor").each -> new App.ItineraryEditor(el: this)
