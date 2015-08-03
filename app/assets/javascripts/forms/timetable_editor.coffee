DATE_FORMAT = "YYYY-MM-DD"
TIME_FORMAT = DATE_FORMAT + " HH:mm:ss"

class App.TimetableEditor extends Spine.Controller
  elements:
    ".popup[rel=activity-type]": "activityTypeSelector"
    ".activity-list": "activityList"
    ".timetable": "timetable"

  init: ->
    @dragula()
    App.ActivityType
      .one("refresh", @refreshActivityTypes)
    App.Activity
      .one("refresh", @refreshActivities)
    App.TimeSlot
      .one("refresh", @refreshTimeSlots)
      .on("create", @createTimeSlot)
      .on("changeID", @changeTimeSlotID)
      .on("destroy", @destroyTimeSlot)
    App.ScheduledActivity
      .one("refresh", @refreshScheduledActivities)
      # .on("create", @createScheduledActivity)
      .on("update", @updateScheduledActivity)
      .on("changeID", @changeScheduledActivityID)
      .on("destroy", @destroyScheduledActivity)
    @loadJSON()

  dragula: ->
    @drake ||= window.poops = dragula
      containers: @$(".activity-list").get()
      removeOnSpill: true
      copy: true
      accepts: (el, target) =>
        return false if $(target).hasClass("activity-list")
        return false if $(target).children(".timetable-activity[data-id=#{$(el).data("id")}]:not(.gu-transit)").length
        true
    .on("drag", @dragActivity)
    .on("drop", @dropActivity)
    .on("cancel", @cancelDrag)
    .on("over", @dragOver)
    .on("out", @dragOut)
    .on("clone", @cloneActivity)

  dragActivity: (el, container) =>
    unless $(container).hasClass("activity-list")
      setTimeout ->
        el.remove()
      , 0

  dropActivity: (el, container) =>
    item = $(el)
    activity = App.Activity.find(item.data("id"))
    scheduleID = item.data("schedule-id")
    schedule = scheduleID && App.ScheduledActivity.find(scheduleID)

    if $(container).hasClass("times")
      startTime = if (prv = item.prev(".time-slot")).length
        moment(prv.data("end-time"))
      else if (nxt = item.next(".time-slot")).length
        moment(nxt.data("start-time")).subtract(1, "hour")
      else
        moment(item.closest(".day").data("date")).add(9, "hours")
      endTime = startTime.clone().add(1, "hour")

      event = @event()
      new ScheduleActivityDialog({ event, activity, startTime, endTime })
        .on "ok", (startTime, endTime) =>
          App.ScheduledActivity.createByTimes(@event(), activity, startTime, endTime)
            .done (scheduledActivity) =>
              if @$("[data-schedule-id=#{scheduledActivity.id}]").length
                item.remove()
              else
                item
                  .appendTo(@$(".time-slot[data-id=#{scheduledActivity.time_slot_id}]"))
                  .replaceWith(@renderActivity(activity, scheduledActivity))
                @refreshDragContainers()
            .fail =>
              item.remove()
        .on "cancel", =>
          if schedule
            item
              .appendTo(@$(".time-slot[data-id=#{schedule.time_slot_id}]"))
              .replaceWith(@renderActivity(activity, schedule))
          else
            item.remove()
    else if $(container).hasClass("time-slot")
      timeSlot = App.TimeSlot.find($(container).data("id"))
      if schedule
        schedule.updateAttributes(time_slot_id: timeSlot.id)
        @refreshDragContainers()
      else
        App.ScheduledActivity.createByActivityAndTimeSlot(activity, timeSlot)
          .done (scheduledActivity) =>
            item.replaceWith(@renderActivity(activity, scheduledActivity))
            @refreshDragContainers()
          .fail =>
            item.remove()

  cancelDrag: (el, container) =>
    if $(container).hasClass("activity-list")
      $(el).remove()

  dragOver: (el, container, source) =>
    $(container).closest(".day").addClass("hover")

  dragOut: (el, container, source) =>
    $(container).closest(".day").removeClass("hover")
    @refreshDragContainers()

  cloneActivity: =>
    console.log arguments

  loadJSON: ->
    $.getJSON(@url()).done (data) =>
      moment.tz.setDefault(data.time_zone)
      @event().start_date = data.start_date
      @event().end_date = data.end_date
      App.ActivityType.refresh(data.activity_types)
      App.Activity.refresh(data.activities)
      App.TimeSlot.refresh(($.extend(slot, { event_id: @eventID() }) for slot in data.time_slots))
      App.ScheduledActivity.refresh(data.scheduled_activities)
      @refreshDragContainers()

  url: ->
    "/events/#{@eventID()}/timetable"

  eventID: ->
    @_eventID ||= @$("[name=event_id]").val()

  event: ->
    @_event ||= new App.Event(id: @eventID())

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
        .find(".timetable-activity").hide()
          .filter("[data-activity-type=#{type.id}]").show().end()
        .end()
    @_activityType

  refreshActivities: =>
    @activityList.empty()
    for activity in App.Activity.all()
      @renderActivity(activity).appendTo(@activityList)
        .toggle(activity.activity_type_id == @activityType().id)

  renderActivity: (activity, schedule) ->
    color = Color.pickWithString(activity.activityType().name)
    $(@view("timetable/activity")({ activity, schedule }))
      .css(background: color.shade(100))

  refreshTimeSlots: =>
    @timetable.empty()

    d = @event().startDate().startOf("day")
    while !d.isAfter(@event().endDate())
      @timetable.append @view("timetable/day")(date: d)
      d.add(1, "day")

    App.TimeSlot.each @createTimeSlot

  createTimeSlot: (timeSlot) =>
    @renderTimeSlot(timeSlot)
      .appendTo(@$(".day[data-date=\"#{timeSlot.startTime().format(DATE_FORMAT)}\"] .times"))

  destroyTimeSlot: (timeSlot) =>
    @$(".time-slot[data-id=\"#{timeSlot.id}\"]").remove()

  changeTimeSlotID: (timeSlot, oldID, newID) =>
    @$(".time-slot[data-id=\"#{oldID}\"]").attr("data-id", newID)

  renderTimeSlot: (timeSlot) ->
    $("<div>", class: "time-slot")
      .attr("data-id", timeSlot.id)
      .attr("data-start-time", timeSlot.startTime().format(TIME_FORMAT))
      .attr("data-end-time", timeSlot.endTime().format(TIME_FORMAT))

  refreshScheduledActivities: =>
    App.ScheduledActivity.each @createScheduledActivity

  createScheduledActivity: (scheduled) =>
    @renderActivity(scheduled.activity(), scheduled)
      .appendTo(@$(".time-slot[data-id=\"#{scheduled.time_slot_id}\"]"))

  updateScheduledActivity: (scheduled) =>
    @$(".timetable-activity[data-schedule-id=\"#{scheduled.id}\"]")
      .replaceWith(@renderActivity(scheduled.activity(), scheduled))

  changeScheduledActivityID: (scheduled, oldID, newID) =>
    @$(".timetable-activity[data-schedule-id=\"#{oldID}\"]").attr("data-schedule-id", newID)

  destroyScheduledActivity: (scheduled) =>
    @$(".timetable-activity[data-schedule-id=\"#{scheduled.id}\"]").remove()

  refreshDragContainers: ->
    @$(".time-slot:empty").each ->
      App.TimeSlot.destroy($(this).remove().data("id"))
    @$(".times").each ->
      $(this).append $(this).children(".time-slot").get().sort (a, b) ->
        $(a).data("start-time").localeCompare($(b).data("start-time")) ||
        $(a).data("end-time").localeCompare($(b).data("end-time"))
    @dragula().containers.splice 0, @dragula().containers.length,
      @$(".activity-list, .day .times, .day .time-slot").get()...

class ScheduleActivityDialog extends App.Dialog
  elements:
    "[name=start-date]": "startDateInput"
    "[name=start-time]": "startTimeInput"
    "[name=end-date]": "endDateInput"
    "[name=end-time]": "endTimeInput"
    "footer [rel=ok]": "okButton"

  events:
    "change input": "timesChanged"

  renderContent: ->
    super.append(@view("timetable/schedule_activity")(this))

  shown: ->
    super
    @timesChanged()

  timesChanged: ->
    startTime = moment(@startDateInput.val() + " " + @startTimeInput.val())
    endTime = moment(@endDateInput.val() + " " + @endTimeInput.val())

    if startTime.isValid() && endTime.isValid() && endTime.isAfter(startTime)
      [@startTime, @endTime] = [startTime, endTime]
      @okButton.removeAttr("disabled")
      @endDateInput.attr("min", @startTime.format("YYYY-MM-DD"))
      if @startTime.isSame(@endTime, "day")
        @endTimeInput.attr("min", @startTime.format("HH:mm:ss"))
      else
        @endTimeInput.removeAttr("min")
    else
      @okButton.attr("disabled", true)

  ok: ->
    @trigger "ok", @startTime, @endTime
    @hide()

$ ->
  $(".timetable-editor").each ->
    window.editor = new App.TimetableEditor(el: this)
