window.Tool = class

  onMouseDown: ->
  onMouseUp: ->
  onMouseMove: ->
  onClick: ->
  onDoubleClick: ->


  @createTool: (canvas, id = 'select')->
    if id == 'polygon'
      new PolygonTool canvas
    else if id == 'rectangle'
      new RectangleTool canvas
    else if id == 'select'
      new SelectTool canvas

  setAttr: (@attr) ->

window.Attr = class
  constructor: (@strokeColor = '#000000', @fillColor = '#ff0000', @strokeWidth = 1, @strokeJoin = 'miter') ->

  build: ->
    'stroke': @strokeColor
    'stroke-width': @strokeWidth
    'stroke-linejoin': @strokeJoin
    'fill': @fillColor


