window.Image = class
  constructor: ->
    @imageFile = ko.observable()
    @imageObjectURL = ko.observable()
    @imageBinary = ko.observable()