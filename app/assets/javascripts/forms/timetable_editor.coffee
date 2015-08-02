DATE_FORMAT = "YYYY-MM-DD"

class App.TimetableEditor extends Spine.Controller
  elements:
    ".popup[rel=activity-type]": "activityTypeSelector"
    ".activity-list": "activityList"
    ".timetable": "timetable"

  init: ->
    @dragula()
    App.ActivityType.on("refresh change", @refreshActivityTypes)
    App.Activity.on("refresh change", @refreshActivities)
    App.TimeSlot.on("refresh change", @refreshTimeSlots)
    @loadJSON()

  dragula: ->
    @drake ||= window.poops = dragula
      containers: @$(".activity-list").get()
      removeOnSpill: true
      accepts: (el, target) =>
        !$(target).hasClass("activity-list")
    .on("drag", @dragActivity)
    .on("drop", @dropActivity)
    .on("cancel", @cancelDrag)
    .on("over", @dragOver)
    .on("out", @dragOut)

  dragActivity: (el, container) =>
    if $(container).hasClass("activity-list")
      setTimeout ->
        clone = $(el).clone().removeClass("gu-transit").insertAfter(el)
        $(".gu-mirror").css(width: clone.outerWidth(), height: clone.outerHeight())
      , 0

  dropActivity: (el, container) =>
    if $(container).hasClass("times")
      slot = $(el).wrap("<div class=\"time-slot\">").parent()
      startTime = if (prv = slot.prev(".time-slot")).length
        moment(prv.data("end-time"))
      else if (nxt = slot.prev(".time-slot")).length
        moment(prv.data("end-time")).subtract(1, "hour")
      else
        moment(slot.closest(".day").data("date")).add(9, "hours")
      endTime = startTime.clone().add(1, "hour")
      slot
        .attr("data-start-time", startTime.toISOString())
        .attr("data-end-time", endTime.toISOString())
      activity = App.Activity.find($(el).data("id"))
      new ScheduleActivityDialog({ activity, startTime, endTime })
      @refreshDragContainers()

  cancelDrag: (el, container) =>
    if $(container).hasClass("activity-list")
      $(el).remove()

  dragOver: (el, container, source) =>
    $(container).closest(".day").addClass("hover")

  dragOut: (el, container, source) =>
    $(container).closest(".day").removeClass("hover")
    @refreshDragContainers()

  loadJSON: ->
    $.getJSON(@url()).done (data) =>
      moment.tz.setDefault(data.time_zone)
      @_startDate = moment(data.start_date)
      @_endDate = moment(data.end_date)
      App.ActivityType.refresh(data.activity_types)
      App.Activity.refresh(data.activities)
      App.TimeSlot.refresh(data.time_slots)
      @refreshDragContainers()

  url: ->
    "/events/#{@eventID()}/timetable"

  eventID: ->
    @_eventID ||= @$("[name=event_id]").val()

  refreshActivityTypes: =>
    types = App.ActivityType.all()
    @$("aside header").toggle(types.length > 1)
    @activityTypeSelector.find(".action-list").empty()
      .append (@renderActivityType(type) for type in types)
    @activityType(types[0]) unless @activityType()

  renderActivityType: (type) ->
    $("<li>").append(
      $("<a>", href: "#", rel: type.id).append(
        $("<span>", text: type.plural)
      )
    )

  activityType: (type) ->
    if type?
      @_activityType = type
      @activityTypeSelector
        .find(".popup-toggle-label").text(type.plural).end()
        .find("a")
          .parent().show().end()
          .filter("[rel=#{type.id}]").parent().hide().end().end()
        .end()
      @activityList
        .find(".activity").hide()
          .filter("[data-activity-type=#{type.id}]").show().end()
        .end()
    @_activityType

  refreshActivities: =>
    @activityList.empty()
    for activity in App.Activity.all()
      @renderActivity(activity).appendTo(@activityList)
        .toggle(activity.activity_type_id == @activityType().id)

  renderActivity: (activity) ->
    color = Color.pickWithString(activity.activityType().name)
    $(@view("timetable/activity")({ activity }))
      .css(background: color.shade(100))

  refreshTimeSlots: =>
    @timetable.empty()

    d = @_startDate.clone().startOf("day")
    while !d.isAfter(@_endDate)
      @timetable.append @view("timetable/day")(date: d)
      d.add(1, "day")

  refreshDragContainers: ->
    @$(".time-slot:empty").remove()
    @dragula().containers.splice 0, @dragula().containers.length,
      @$(".activity-list, .day .times, .day .time-slot").get()...

class ScheduleActivityDialog extends App.Dialog
  renderContent: ->
    html = @view("timetable/schedule_activity")(this)
    super.append(html)

$ ->
  $(".timetable-editor").each ->
    window.editor = new App.TimetableEditor(el: this)
