window.Polygon = class extends Shape
  @SnappingDistance: 10

  constructor: (@canvas) ->

  startDrawing: (p, @attr) ->
    @points = [p]
    @createPath @generatePathString()

  stopDrawing: (p) ->
    pathString = @generatePathString()
    @createPath(pathString)
    Events.trigger 'shape.drawn', {shape: @}
    @raphaelShape.click (e) =>
      Events.trigger 'shape.click', {shape: @}


  import: (path) ->
    @raphaelShape = path
    @

  redraw: (p) ->
    @points.pop() unless @points.length == 1
    @points.push p
    @raphaelShape.remove()
    @createPath @generatePathString()
    @tryClose(p)

  addPoint: (p) ->
    @points.push p

  tryClose: (p) ->
    if @points.length > 3 && @pointsWithinSnappingRange(@points.first(), @points.last())
      @raphaelShape.remove()
      @snapClose()


  pointsWithinSnappingRange: (p1, p2) ->
    Math.abs(p1.X - p2.X) <= Polygon.SnappingDistance && Math.abs(p1.Y - p2.Y) <= Polygon.SnappingDistance

  snapClose: ->
    @points.pop()
    pathString = @generatePathString() + "z"
    @createPath(pathString)
    Events.trigger 'shape.drawn', {shape: @}
    @raphaelShape.click (e) =>
      Events.trigger 'shape.click', {shape: @}

  createPath: (pathString)->
    @raphaelShape = @canvas.path(pathString)
    @raphaelShape.attr(@attr)
    @raphaelShape

  generatePathString: ->
    reduceF = (acc, p, i) ->
      pathLetter = if i == 0 then 'M' else 'L'
      "#{acc}#{pathLetter}#{p.X},#{p.Y}"
    @points.reduce(reduceF, '')

  jsonData: ->
    attr = @raphaelShape.attr()
    attr.type = 'path'
    {
      shape: 'polygon'
      data: attr
    }

