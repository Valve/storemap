fs     = require 'fs'
{exec} = require 'child_process'

appFiles = [
  'src/util.coffee',
  'src/ko/bindings/file.coffee',
  'src/view_models/floor.coffee',
  'src/view_models/shop.coffee',
  'src/view_models/category.coffee',
  'src/view_models/workspace.coffee',
  'src/view_models/shop.js.coffee',
  'src/view_models/image.coffee',
  'src/events.coffee',
  'src/point.coffee',
  'src/shape.coffee',
  'src/rectangle.coffee',
  'src/polygon.coffee',
  'src/tool.coffee',
  'src/polygon_tool.coffee',
  'src/select_tool.coffee',
  'src/rectangle_tool.coffee'
  'src/vector_editor.coffee',
]

task 'build', 'Build single application file from source files', ->
  appContents = new Array remaining = appFiles.length
  for file, index in appFiles then do (file, index) ->
    fs.readFile file, 'utf8', (err, fileContents) ->
      throw err if err
      appContents[index] = fileContents
      process() if --remaining is 0
  process = ->
    fs.writeFile 'gen/app.coffee', appContents.join('\n\n'), 'utf8', (err) ->
      throw err if err
      exec 'coffee --compile gen/app.coffee', (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr
        fs.unlink 'gen/app.coffee', (err) ->
          throw err if err
          console.log 'Done.'
