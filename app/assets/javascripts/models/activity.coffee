class App.Activity extends Spine.Model
  @configure "Activity", "name", "description", "event_id", "activity_type_id"
  @extend Spine.Model.Ajax

  url: -> "/events/#{@event_id}/activities"

  activityType: ->
    App.ActivityType.find(@activity_type_id)

  @sorted: ->
    @all().slice(0).sort (a, b) ->
      a.name.toLocaleLowerCase().localeCompare(b.name.toLocaleLowerCase())
