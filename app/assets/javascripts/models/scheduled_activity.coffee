class App.ScheduledActivity extends Spine.Model
  @configure "ScheduledActivity", "activity_id", "time_slot_id"
  @extend Spine.Model.Ajax

  url: -> "/events/#{@timeSlot().event_id}/scheduled_activities"

  timeSlot: ->
    @_timeSlot = App.TimeSlot.find(@time_slot_id)

  startTime: ->
    @timeSlot().startTime()

  endTime: -> @timeSlot().endTime()

  activity: ->
    @_activity = App.Activity.find(@activity_id)

  @createByTimes: (event, activity, startTime, endTime) ->
    promise = $.Deferred()
    App.TimeSlot.findOrCreateByTimes(event, startTime, endTime)
      .done (timeSlot) =>
        @createByActivityAndTimeSlot(activity, timeSlot)
          .done (scheduledActivity) -> promise.resolve(scheduledActivity)
          .fail -> promise.reject()
    promise

  @createByActivityAndTimeSlot: (activity, timeSlot) ->
    promise = $.Deferred()
    for record in @records
      if record.activity_id == activity.id && record.time_slot_id == timeSlot.id
        promise.reject()

    record = new this(activity_id: activity.id, time_slot_id: timeSlot.id)
    record.one "changeID", (scheduledActivity, oldID, newID) ->
      promise.resolve(scheduledActivity)
    .save(url: "/events/#{timeSlot.event_id}/scheduled_activities")
    promise

App.ScheduledActivity.on "change", ->
  timeSlotIDs = {}
  for schedule in App.ScheduledActivity.all()
    timeSlotIDs[schedule.time_slot_id] = true
  for slot in App.TimeSlot.all()
    slot.destroy() unless timeSlotIDs[slot.id]
