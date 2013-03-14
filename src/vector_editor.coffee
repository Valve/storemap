window.VectorEditor = class

  constructor: (@el, width, height)->
    throw Error('RaphaelJS is not defined') unless Raphael?
    @bindGlobalEvents()
    @jel = $(@el)
    @canvas = Raphael(@el, width, height)
    @bindEvents()
    @shapes = []
    @currentShape = null

  setTool: (id) ->
    @tool = Tool.createTool(@canvas, id)

  bindGlobalEvents: ->
    Events.on 'shape.drawing', (e, args) => 
      @shapes.push args.shape
      @deselectAllShapes()

    Events.on 'shape.removing', (e, args) =>
      @shapes.pop args.shape

    Events.on 'shape.selecting', (e, args) =>
      @deselectAllShapes()

  setAttr: (@attr) -> @tool.setAttr(@attr)

  bindEvents: ->
    @jel.on 'mousedown', (e)=>
      point = new Point(e.offsetX, e.offsetY)
      @onMouseDown(point, e.target)

    @jel.on 'mouseup', (e)=>
      point = new Point(e.offsetX, e.offsetY)
      @onMouseUp(point, e.target)


    @jel.on 'mousemove', (e)=>
      point = new Point(e.offsetX, e.offsetY)
      @onMouseMove(point, e.target)

    @jel.on 'click', (e)=>
      point = new Point(e.offsetX, e.offsetY)
      @onClick(point, e.target)

    @jel.on 'dblclick', (e) =>
      point = new Point(e.offsetX, e.offsetY)
      @onDoubleClick(point, e.target)



  onMouseDown: (p, target)-> @?.tool.onMouseDown(p)

  onMouseUp: (p, target)-> @?.tool.onMouseUp(p)

  onMouseMove: (p, target)->
    @displayCoordinates(p)
    @?.tool.onMouseMove(p)

  onClick: (p, target) -> @?.tool.onClick(p)

  onDoubleClick: (p, target) -> @?.tool.onDoubleClick(p)



  deselectLastShape: ->
    @shapes.last()?.deselect()

  deselectAllShapes: ->
    shape.deselect() for shape in @shapes


  displayCoordinates: (p)->
    # optimize
    $('#mouse_x').text('X: '+ p.X)
    $('#mouse_y').text('  Y: '+ p.Y)

  selectShape: (shape) ->
    @currentShape = shape
    @onShapeSelected(shape)


  setStrokeColor: (color) ->
    @strokeColor = color
    @currentShape.attr('stroke': color) if @currentShape

  setStrokeWidth: (width) ->
    @strokeWidth = width
    @currentShape.attr('stroke-width': width) if @currentShape

  setStrokeLineJoin: (value) ->
    @strokeLineJoin = value
    @currentShape.attr('stroke-linejoin': value) if @currentShape


  setFillColor: (color) ->
    @fillColor = color
    @currentShape.attr('fill': color) if @currentShape

  jsonData: -> shape.jsonData() for shape in @shapes





