window.RectangleTool = class extends Tool

  constructor: (@canvas, @attr) ->
    @bindEvents()

  onMouseDown: (p) ->
    @mouseDownP = p
    @rect = new Rectangle(@canvas)
    @rect.startDrawing(p, @attr)
    @bindEvents()
    Events.trigger 'shape.drawing', {p:p, shape: @rect, tool: @}

  onMouseUp: (p) ->
    if p.equals(@mouseDownP)
      @deleteRect()
    else
      Events.trigger 'shape.drawn', {p:p, shape: @rect, tool: @}
    @mouseDownP = null


  onMouseMove: (p) ->
    @rect.resize(p) if @mouseDownP

  bindEvents: ->
    Events.on 'shape.resizing', (e, args) =>
      @rect = args.shape
      @mouseDownP = args.p
    Events.on 'shape.resized', (e, args) => @mouseDownP = null

  deleteRect: ->
    Events.trigger 'shape.removing', {shape: @rect}
    @rect.finalize()
    @rect = null
    Events.trigger 'shape.removed', {shape: null}



