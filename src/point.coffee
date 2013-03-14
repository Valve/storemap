window.Point = class
  constructor: (x, y)->
    @X = x
    @Y = y

  toString: -> "[#{@X}, #{@Y}]"

  equals: (other) ->
    return false unless other?
    return false unless other instanceof Point
    other.X == @X && other.Y == @Y