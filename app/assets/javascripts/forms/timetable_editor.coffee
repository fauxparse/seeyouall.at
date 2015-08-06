DATE_FORMAT = "YYYY-MM-DD"
TIME_FORMAT = DATE_FORMAT + " HH:mm:ss"

class App.TimetableEditor extends Spine.Controller
  elements:
    ".popup[rel=activity-type]": "activityTypeSelector"
    ".activity-list": "activityList"
    ".timetable": "timetable"

  events:
    "click .floating-action-button [data-activity-type-id]": "newActivity"
    "click aside [data-activity-type-id]": "chooseActivityType"
    "click aside [rel=new-activity-type]": "newActivityType"
    "click .timetable-activity [rel=edit]": "editActivity"

  init: ->
    @dragula()
    App.ActivityType
      .one("refresh", @refreshActivityTypes)
      .on("change", @refreshActivityTypes)
      .on("changeID", @activityTypeCreated)
    App.Activity
      .one("refresh", @refreshActivities)
      .on("change", @refreshActivities)
      .on("changeID", @changeActivityID)
      .on("update", @updateActivity)
      .on("create", @switchToTypeOfNewActivity)
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
    @timetable.on("scroll", @timetableScrolled)
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
    .on("dragend", @dragEnd)

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
                @refreshDragContainers()
              else
                item
                  .appendTo(@$(".time-slot[data-id=#{scheduledActivity.time_slot_id}]"))
                  .replaceWith(@renderActivity(activity, scheduledActivity))
                @refreshDragContainers()
            .fail =>
              item.remove()
              @refreshDragContainers()
        .on "cancel", =>
          if schedule
            item
              .appendTo(@$(".time-slot[data-id=#{schedule.time_slot_id}]"))
              .replaceWith(@renderActivity(activity, schedule))
          else
            item.remove()
            @refreshDragContainers()
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
            @refreshDragContainers()

  cancelDrag: (el, container) =>
    if $(container).hasClass("activity-list")
      $(el).remove()
    @refreshDragContainers()

  dragOver: (el, container, source) =>
    @_dragOverContainer = container
    $(container).closest(".day").addClass("hover")
    @refreshDragContainers()

  dragOut: (el, container, source) =>
    @_dragOverContainer = null
    $(container).closest(".day").removeClass("hover")
    @refreshDragContainers()

  dragEnd: (el) =>
    el = $(el)
    if (schedule = el.data("schedule-id")) && !@_dragOverContainer
      App.ScheduledActivity.destroy(schedule)

  loadJSON: ->
    $.getJSON(@url()).done (data) =>
      moment.tz.setDefault(data.time_zone)
      @event().start_date = data.start_date
      @event().end_date = data.end_date
      App.ActivityType.refresh(data.activity_types)
      App.Activity.refresh(($.extend(a, { event_id: @eventID() }) for a in data.activities))
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
    # @$("aside header").toggle(types.length > 1)
    @activityTypeSelector.find(".types").empty()
      .append((@renderActivityType(type) for type in types))
    @activityType(types[0]) unless @activityType()
    list = @$(".floating-action-button .action-list")
    list.find("[data-activity-type-id]").parent().remove()
    list.append((@renderNewActivityButton(type) for type in types))
    list.find("[rel=cancel]").parent().appendTo(list)

  renderActivityType: (type, label = type.plural) ->
    $("<li>").append(
      $("<a>", href: "#", "data-activity-type-id": type.id, text: type.plural)
    )

  renderNewActivityButton: (type) ->
    color = type.color()
    $("<li>").append(
      $("<a>", href: "#", "data-activity-type-id": type.id).append(
        $("<i>", class: "activity-type-icon", style: "background-color: #{color.shade(500)}", text: type.name.substr(0, 1).toLocaleUpperCase()),
        $("<span>", text: I18n.t("activities.new_of_type", {type}))
      )
    )

  activityType: (type) =>
    if type?
      @_activityType = type
      @activityTypeSelector
        .find(".popup-toggle-label").text(type.plural).end()
        .find("[data-activity-type-id=#{type.id}]")
          .parent().prependTo(@activityTypeSelector.find(".types")).end()
        .end()
      @activityList
        .find(".timetable-activity").hide()
          .filter("[data-activity-type=#{type.id}]").show().end()
        .end()
    @_activityType

  chooseActivityType: (e) ->
    e.preventDefault()
    id = $(e.target).closest("[data-activity-type-id]").data("activity-type-id")
    if type = App.ActivityType.find(id)
      @activityType(type)

  newActivityType: (e) ->
    e.preventDefault()
    activityType = new App.ActivityType
    event = @event()
    new EditActivityTypeDialog({ activityType, event })

  activityTypeCreated: (activityType) =>
    setTimeout =>
      @refreshActivityTypes()
      @activityType(activityType)
    , 0

  refreshActivities: =>
    @activityList.empty()
    for activity in App.Activity.sorted()
      @renderActivity(activity).appendTo(@activityList)
        .toggle(activity.activity_type_id == @activityType().id)

  renderActivity: (activity, schedule) ->
    color = activity.activityType().color()
    $(@view("timetable/activity")({ activity, schedule }))
      .css(background: color.translucent(0.3))

  updateActivity: (activity) =>
    @$(".timetable-activity[data-id=#{activity.id}][data-schedule-id]").each (i, el) =>
      el = $(el)
      schedule = App.ScheduledActivity.find(el.data("schedule-id"))
      el.replaceWith @renderActivity(activity, schedule)

  changeActivityID: (activity, oldID, newID) =>
    @$(".timetable-activity[data-id=#{oldID}]").attr("data-id", newID)

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
    schedule = @$(".timetable-activity[data-schedule-id=\"#{scheduled.id}\"]")
    unless schedule.closest(".time-slot").data("id") == scheduled.time_slot_id.toString()
      setTimeout =>
        @$("[data-schedule-id=#{scheduled.id}]").appendTo(@$(".time-slot[data-id=#{scheduled.time_slot_id}]"))
        @refreshDragContainers()
      , 0
    schedule.replaceWith(@renderActivity(scheduled.activity(), scheduled))

  changeScheduledActivityID: (scheduled, oldID, newID) =>
    @$(".timetable-activity[data-schedule-id=\"#{oldID}\"]").attr("data-schedule-id", newID)

  destroyScheduledActivity: (scheduled) =>
    @$(".timetable-activity[data-schedule-id=\"#{scheduled.id}\"]").remove()

  refreshDragContainers: ->
    # @$(".time-slot:empty").each ->
    #   App.TimeSlot.destroy($(this).remove().data("id"))
    @$(".times").each ->
      $(this).append $(this).children(".time-slot").get().sort (a, b) ->
        $(a).data("start-time").localeCompare($(b).data("start-time")) ||
        $(a).data("end-time").localeCompare($(b).data("end-time"))
    @dragula().containers.splice(
      0, @dragula().containers.length,
      @$(".activity-list, .day .times, .day .time-slot").get()...
    )
    top = @timetable.scrollTop()
    @$(".day h3").each ->
      day = $(this)
      pos = day.position()
      h3 = day.find(".weekday")
      day
        .data("height", day.outerHeight() + pos.top)
        .data("top", pos.top + top + day.parent().position().top)
        .data("offset", h3.position().top + h3.outerHeight())
    @timetableScrolled()

  newActivity: (e) ->
    activityType = App.ActivityType.find($(e.target).closest("[data-activity-type-id]").data("activity-type-id"))
    activity = new App.Activity(activity_type_id: activityType.id)
    event = @event()
    new EditActivityDialog({ activity, event })

  editActivity: (e) ->
    e.preventDefault()
    el = $(e.target).closest(".timetable-activity")
    activity = App.Activity.find(el.data("id"))
    scheduleID = el.data("schedule-id")
    schedule = scheduleID && App.ScheduledActivity.find(scheduleID)
    event = @event()
    new EditActivityDialog({ activity, event, schedule })

  newActivityType: (e) ->
    activityType = new App.ActivityType()
    event = @event()
    new EditActivityTypeDialog({ activityType, event })

  switchToTypeOfNewActivity: (activity) =>
    @activityType(activity.activityType())

  timetableScrolled: =>
    top = @timetable.scrollTop()
    @$(".day h3").each (_, i) ->
      day = $(this)
      y = day.data("top")
      h = day.data("height") - day.data("offset")
      day.css(y: Math.max(Math.min(h - 8, top - y + 8), 0))

class ScheduleActivityDialog extends App.Dialog
  elements:
    "[name=start-date]": "startDateInput"
    "[name=start-time]": "startTimeInput"
    "[name=end-date]": "endDateInput"
    "[name=end-time]": "endTimeInput"
    "footer [rel=ok]": "okButtons"

  events:
    "change input[type=date]": "timesChanged"
    "change input[type=time]": "timesChanged"

  renderContent: ->
    super
      .append($("<h4>", class: "dialog-title", text: @activity.name))
      .append(@view("timetable/schedule_activity")(this))

  shown: ->
    super
    @timesChanged()
    @startDateInput.focus()

  timesChanged: ->
    startTime = moment(@startDateInput.val() + " " + @startTimeInput.val())
    endTime = moment(@endDateInput.val() + " " + @endTimeInput.val())

    if startTime.isValid() && endTime.isValid() && endTime.isAfter(startTime)
      [@startTime, @endTime] = [startTime, endTime]
      @okButtons.removeAttr("disabled")
      @endDateInput.attr("min", @startTime.format("YYYY-MM-DD"))
      if @startTime.isSame(@endTime, "day")
        @endTimeInput.attr("min", @startTime.format("HH:mm:ss"))
      else
        @endTimeInput.removeAttr("min")
    else
      @okButtons.attr("disabled", true)

  ok: ->
    @trigger "ok", @startTime, @endTime
    @hide()

  keypress: (e) =>
    if e.which == 13
      @ok()
    else
      super

class EditActivityDialog extends ScheduleActivityDialog
  elements:
    "[name=name]": "nameInput"
    "[name=description]": "description"
    "[rel=activity-type-id] .popup-toggle-label": "activityTypeLabel"
    "[name=start-date]": "startDateInput"
    "[name=start-time]": "startTimeInput"
    "[name=end-date]": "endDateInput"
    "[name=end-time]": "endTimeInput"
    "footer [rel=ok]": "okButton"
    "footer [rel=another]": "addAnotherButton"
    "footer [rel=ok], footer [rel=another]": "okButtons"

  events:
    "input input": "inputChanged"
    "change input": "inputChanged"
    "input textarea": "inputChanged"
    "change textarea": "inputChanged"
    "click [data-activity-type-id]": "changeActivityType"
    "change input[type=date]": "timesChanged"
    "change input[type=time]": "timesChanged"

  init: ->
    if @schedule
      [@startTime, @endTime] = [@schedule.startTime(), @schedule.endTime()]
    super
    @addAnotherButton.toggle(@activity.isNew())
    @_activityTypeID = @activity.activity_type_id

  renderContent: ->
    content = $("<div>", class: "dialog-content")
    content.append(@view("timetable/edit_activity")(this))
    if @schedule
      content.append(@view("timetable/schedule_activity")(this))
    content

  renderFooter: ->
    super.append($("<button>", rel: "another", text: I18n.t("activities.add_another")))

  show: ->
    super
    @inputChanged()

  shown: ->
    super
    @nameInput.focus()

  save: ->
    promise = $.Deferred()
    @activity.name = @nameInput.val()
    @activity.description = @description.val()
    @activity.activity_type_id = @_activityTypeID
    if @schedule
      App.TimeSlot.findOrCreateByTimes(@event, @startTime, @endTime)
        .done (timeSlot) =>
          for s in App.ScheduledActivity.all()
            if s.id != @schedule.id && s.activity_id == @activity.id && s.time_slot_id == timeSlot.id
              promise.reject()
              return
          unless timeSlot.id == @schedule.time_slot_id
            @schedule.time_slot_id = timeSlot.id
            @schedule.save()
          @activity.save(url: @url())
          promise.resolve()
    else
      @activity.save(url: @url())
      promise.resolve()
    promise

  ok: ->
    # TODO show the user the clash
    @save().done => @hide()

  another: ->
    @save()
    @activity = new App.Activity(activity_type_id: @activity.activity_type_id)
    @nameInput.val("").focus()

  url: ->
    id = !@activity.isNew() && "/#{@activity.id}" || ""
    "/events/#{@event.id}/activities#{id}"

  inputChanged: ->
    @okButtons.prop("disabled", !!@$(":invalid").length)

  changeActivityType: (e) ->
    typeID = $(e.target).closest("a").data("activity-type-id")
    @_activityTypeID = typeID
    @activityTypeLabel.text(@activity.activityType().name)

  keypress: (e) =>
    if e.which == 13
      return if $(e.target).closest("textarea").length

      if @addAnotherButton.is(":visible")
        @another()
      else
        @ok()
    else
      super

class EditActivityTypeDialog extends App.Dialog
  elements:
    "[name=name]": "nameInput"
    "footer [rel=ok]": "okButton"

  events:
    "input input": "inputChanged"
    "change input": "inputChanged"

  renderContent: ->
    super.append(@view("timetable/edit_activity_type")(this))

  shown: ->
    super
    @nameInput.focus()

  inputChanged: ->
    @okButton.prop("disabled", !!@$(":invalid").length)

  save: ->
    @activityType.name = @nameInput.val()
    @activityType.save(url: @url())

  ok: ->
    @save()
    @hide()

  url: ->
    id = !@activityType.isNew() && "/#{@activityType.id}" || ""
    "/events/#{@event.id}/activity_types#{id}"

$ ->
  $(".timetable-editor").each ->
    window.editor = new App.TimetableEditor(el: this)
