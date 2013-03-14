window.Rectangle = class extends Shape

  constructor: (@canvas) ->
    super()

  startDrawing: (p, attr) ->
    @raphaelShape = @canvas.rect(p.X, p.Y, 0, 0).attr(attr)
    @bindEvents()

  import: (shape) ->
    @raphaelShape = shape
    @bindEvents()
    @

  bindEvents: ->
    @raphaelShape.click (e) =>
      e.preventDefault()
      Events.trigger('shape.click', {shape: @})

  resize: (p) ->
    w = p.X - @x()
    h = p.Y - @y()
    if(w > 0 && h > 0)
      @raphaelShape.attr(width: w, height: h)


  jsonData: ->
    attr = @raphaelShape.attr()
    attr.type = 'rect'
    {
      shape: 'rectangle'
      data: attr
    }
