window.Shape = class
  constructor: ->
    @raphaelShape = null


  select: ->
    unless @ft
      @ft = @canvas.freeTransform(@raphaelShape, {rotate: false})
    @ft.showHandles()
    @selected = true

  deselect: ->
    @ft.hideHandles() if @ft
    @selected = false

  finalize: ->
    Events.trigger('shape.removing', shape: @)
    @ft.unplug()
    @raphaelShape.remove()
    Events.trigger('shape.removed', shape: @)

  x: -> @raphaelShape.attr('x')
  y: -> @raphaelShape.attr('y')
  w: -> @raphaelShape.attr('width')
  h: -> @raphaelShape.attr('height')

  setAttr: (attr) -> @raphaelShape.attr(attr)


  @fromRaphaelShape: (type, canvas, raphaelShape) ->
    if type == 'rectangle'
      shape = new Rectangle(canvas)
    else if type == 'polygon'
      shape = new Polygon(canvas)
    shape.import(raphaelShape)
