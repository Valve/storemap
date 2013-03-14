window.SelectTool = class extends Tool

  constructor: (context)->
    super(context)
    Events.off 'shape.click'
    Events.on 'shape.click', (e, args) => 
      shapeSelected = args.shape.selected
      if shapeSelected
        Events.trigger 'shape.deselecting', {shape: args.shape}
        args.shape.deselect()
        Events.trigger 'shape.deselected', {shape: args.shape}
      else
        Events.trigger 'shape.selecting', {shape: args.shape}
        args.shape.select()
        Events.trigger 'shape.selected', {shape: args.shape}


  onMouseDown: (p) ->

  onMouseUp: (p) ->

  onMouseMove: (p) ->

  onClick: (p) ->

  onKeyDown: (e) ->
    console.log(e)



