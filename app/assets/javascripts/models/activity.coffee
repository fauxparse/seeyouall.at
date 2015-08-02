class App.Activity extends Spine.Model
  @configure "Activity", "name"

  activityType: ->
    App.ActivityType.find(@activity_type_id)
