class App.ActivityType extends Spine.Model
  @configure "ActivityType", "event_id", "name", "plural"

  toString: -> @name
