window.Floor = class
  constructor: (@number = 0)->
    @attr = new Attr()
    @currentShape = ko.observable()
    @currentShop = ko.observable()
    @shops = []
    Events.on 'shape.selected', (e, args) =>
      @currentShape(args.shape)
      @currentShop(args.shape.shop)
    Events.on 'shape.removing', (e, args) =>
      if args.shape == @currentShape()
        @currentShape(null)
        @currentShop(null)

  initCanvas: ->
    @jcanvas = $("#canvas#{@number}")
    @jcanvas.height($(window).height() - 200)
    # TODO: hackety hack, find out why canvas div has width = 0
    @jcanvas.width(@jcanvas.parent().parent().width()-2)

  initEditor: ->
    @editor = new VectorEditor(@jcanvas.get(0), @jcanvas.width(), @jcanvas.height())

  setTool: (tool)->
    @initEditor() unless @editor
    @editor.setTool tool
    @editor.setAttr @attr.build()

  attrChanged: ->
    @editor.setAttr @attr.build() if @editor
    @currentShape().setAttr @attr.build() if @currentShape()

  jsonData: ->
    number: @number
    shapes: @editor.jsonData()

  name: -> "Floor #{@number}"
  href: -> "#floor#{@number}"
  tabPaneId: -> "floor#{@number}"
  canvasId: -> "canvas#{@number}"

  deserialize: (jsonData) ->
    @initCanvas()
    @initEditor()
    for shapeJson in jsonData.shapes
      raphaelShape = @editor.canvas.add([shapeJson.data])[0]
      shape = Shape.fromRaphaelShape(shapeJson.shape, @editor.canvas, raphaelShape)
      @editor.shapes.push shape

  removeSelectedShape: =>
    @currentShape().finalize()
    @currentShape(null)
