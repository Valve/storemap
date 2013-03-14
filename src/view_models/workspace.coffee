window.Workspace = class
  constructor: (name)->
    @name = ko.observable(name)
    @floors = ko.observableArray()
    @currentFloor = ko.observable()
    @hasFloors = ko.computed => @floors().length > 0
    @selectToolClass = ko.computed => @toolCssClass SelectTool
    @rectangleToolClass = ko.computed => @toolCssClass RectangleTool
    @polygonToolClass = ko.computed => @toolCssClass PolygonTool
    @strokeColor = ko.computed(
      read: -> @currentFloor()?.attr.strokeColor
      write: (value)->
        if @currentFloor()
          @currentFloor().attr.strokeColor = value
          @currentFloor().attrChanged()
      owner: @
    )
    @strokeWidth = ko.computed(
      read: -> @currentFloor()?.attr.strokeWidth
      write: (value)->
        if @currentFloor()
          @currentFloor().attr.strokeWidth = value
          @currentFloor().attrChanged()
      owner: @
    )
    @strokeJoin = ko.computed(
      read: -> @currentFloor()?.attr.strokeJoin
      write: (value)->
        if @currentFloor()
          @currentFloor().attr.strokeJoin = value
          @currentFloor().attrChanged()
      owner: @
    )
    @fillColor = ko.computed(
      read: -> @currentFloor()?.attr.fillColor
      write: (value)->
        if @currentFloor()
          @currentFloor().attr.fillColor = value
          @currentFloor().attrChanged()
      owner: @
    )
    @currentShape = ko.computed => @currentFloor()?.currentShape()
    @currentShop = ko.computed => @currentFloor()?.currentShop()
    @canAddShop = ko.computed => @currentShape() && !@currentShop()
    @canRemoveShop = ko.computed => @currentShape() && @currentShop()
    @shopName = ko.computed(@shopComputedProp('name'))
    @shopUrl = ko.computed(@shopComputedProp('url'))
    @shopDescription = ko.computed(@shopComputedProp('description'))
    @shopName = ko.computed(@shopComputedProp('name'))
    @shopPhone = ko.computed(@shopComputedProp('phone'))

    @shopLogoImageFile = ko.computed(
      read: -> @currentShop()?.logo().imageFile()
      write: (value) ->
        if @currentShop()
          @currentShop().logo().imageFile(value)
      owner: @
    )
    @shopLogoImageBinary = ko.computed(
      read: -> @currentShop()?.logo().imageBinary()
      write: (value) ->
        if @currentShop()
          @currentShop().logo().imageBinary(value)
      owner: @
    )

    @shopLogoImageObjectURL = ko.computed(
      read: -> @currentShop()?.logo().imageObjectURL()
      write: (value) ->
        if @currentShop()
          @currentShop().logo().imageObjectURL(value)
      owner: @
    )

    @shopImages = ko.computed(
      read: -> @currentShop()?.images()
      write: (values) ->
        if @currentShop()
          @currentShop().images(values)
      owner: @
    )


  toolCssClass: (toolConstructor) ->
    klass = "btn"
    klass += " active" if @currentFloor()?.editor?.tool instanceof toolConstructor
    klass

  shopComputedProp: (attr)->
    read: -> @currentShop()?[attr]()
    write: (value) ->
      if @currentShop()
        @currentShop()[attr](value)
    owner: @

  setSelectTool: ->
    @currentFloor().setTool('select')

  setRectangleTool: ->
    @currentFloor().setTool('rectangle')

  setPolygonTool: ->
    @currentFloor().setTool('polygon')

  addFloor: =>
    number = @floors().length + 1
    @floors.push new Floor(number)
    @activateLastFloor()

  removeFloor: (floor) =>
    @floors.remove(floor)
    @activateLastFloor()

  activateFloor: (floor) =>
    @currentFloor(floor)

  removeSelectedShape: =>
    @currentFloor().removeSelectedShape()


  activateLastFloor: ->
    unless @floors().empty()
      @currentFloor  @floors().last()
      $('#floor_tabs a:last').tab('show')

  addShopImage: ->
    if @currentShop()
      @currentShop().images.push(new Image())
      Holder.run() #to turn on holder placeholders for dynamic image tags

  removeShopImage: (img) =>
    if @currentShop()
      @currentShop().images.remove(img)

  initCanvas: =>
    @floors().last().initCanvas() unless @deserializing

  addShop: ->
    shop = new Shop()
    @currentFloor().currentShape().shop = shop
    @currentFloor().currentShop(shop)

  removeShop: ->
    @currentFloor().currentShape().shop = null
    @currentFloor().currentShop(null)

  saveProject: ->
    # don't change indentation here, unless you know what you're doing
    floors = 
      floor.jsonData() for floor in @floors()
    data = 
      floors: floors
    $.ajax
      url: '/projects'
      type: 'POST'
      data: 
        json: JSON.stringify(data)
      success: -> alert 'Проект сохранен успешно'

  loadProject: ->
    $.ajax
      url: '/projects'
      success: (project) => @deserializeProject(project)
      error: (xhr) ->
        if xhr.status == 404 
          alert 'Проект не  найден'

  deserializeProject: (projectJson) ->
    @deserializing = true
    # optimize
    for floorJson in projectJson.floors
      floor  = new Floor(floorJson.number)
      @floors.push floor # to have knockout create all the tab/canvas html
      floor.deserialize floorJson

    @activateLastFloor()
    @deserializing = false

