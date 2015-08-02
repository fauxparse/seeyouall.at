class App.TimeSlot extends Spine.Model
  @configure "TimeSlot", "start_time", "end_time"

  startTime: (value) ->
    @start_time = value.toISOString() if moment.isMoment(value)
    moment(@start_time)

  endTime: (value) ->
    @end_time = value.toISOString() if moment.isMoment(value)
    moment(@end_time)

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
