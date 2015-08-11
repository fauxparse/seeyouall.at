class Sidebar extends Spine.Controller
  init: ->
    @$(".registration").load("/events/#{@eventID()}/registration/summary")

  eventID: -> $("#event_id").val()

  @instance: ->
    @_instance ||= new this(el: "aside.sidebar")

$ ->
  $("#show-sidebar").on "change", ->
    Sidebar.instance()
