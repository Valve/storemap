window.Shop = class
  constructor: ->
    @name = ko.observable()
    @url = ko.observable()
    @logo = ko.observable(new Image())
    @phone = ko.observable()
    @categories = ko.observableArray()
    @description = ko.observable()
    @images = ko.observableArray()
