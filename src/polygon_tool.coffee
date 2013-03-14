window.PolygonTool = class extends Tool

  constructor: (@canvas, @attr)->

  onClick: (p) ->
    if @polygon
      @polygon.addPoint p
    else
      @startNewPolygon p

  onMouseMove: (p) ->
    if @resizing
      @polygon.resize(@startResizeP, p)
    else
      @polygon.redraw(p) if @polygon

  onDoubleClick: (p) ->
    @polygon.stopDrawing(p) if @polygon

  startNewPolygon: (p)->
    @polygon = new Polygon(@canvas)
    @polygon.startDrawing(p, @attr)
    Events.trigger 'shape.drawing', {p: p, shape: @polygon}
    Events.on 'shape.drawn', (e, args) =>
      if args.shape == @polygon
        @polygon = null

