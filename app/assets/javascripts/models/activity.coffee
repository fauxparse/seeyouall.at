class App.Activity extends Spine.Model
  @configure "Activity", "name", "activity_type_id"

  activityType: ->
    App.ActivityType.find(@activity_type_id)
