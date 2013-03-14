window.Events = {}
Events.on = (event, handler) ->
  jQuery(Events).on(event, handler)
Events.off = (event) -> jQuery(Events).off event
Events.trigger = (event, parameters) -> jQuery(Events).trigger(event, parameters)