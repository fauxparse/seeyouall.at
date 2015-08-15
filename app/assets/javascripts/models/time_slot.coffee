class App.TimeSlot extends Spine.Model
  @configure "TimeSlot", "event_id", "start_time", "end_time"
  @extend Spine.Model.Ajax

  url: -> "/events/#{@event_id}/time_slots"

  startTime: (value) ->
    @start_time = value.toISOString() if moment.isMoment(value)
    moment(@start_time)

  endTime: (value) ->
    @end_time = value.toISOString() if moment.isMoment(value)
    moment(@end_time)

  @findByTimes: (startTime, endTime) ->
    startTime = moment(startTime.toISOString()) unless moment.isMoment(startTime)
    endTime = moment(endTime.toISOString()) unless moment.isMoment(endTime)

    for record in @records
      if record.startTime().isSame(startTime) && record.endTime().isSame(endTime)
        return record
    false

  @findOrCreateByTimes: (event, startTime, endTime) ->
    promise = $.Deferred()

    if timeSlot = @findByTimes(startTime, endTime)
      promise.resolve(timeSlot)
    else
      record = new this(event_id: event.id, start_time: startTime, end_time: endTime)
      record.one "changeID", (timeSlot, oldID, newID) ->
        promise.resolve(timeSlot)
      .save(url: "/events/#{event.id}/time_slots")
    promise

  @comparator: (a, b) ->
    [as, bs] = [a.startTime(), b.startTime()]
    if as.isBefore(bs)
      -1
    else if bs.isBefore(as)
      1
    else if a.endTime().isBefore(b.endTime())
      -1
    else
      1

App.TimeSlot.on "destroy", (timeSlot) =>
  setTimeout =>
    Spine.Ajax.disable => timeSlot.destroy()
  , 1000
