windowURL = window.URL || window.webkitURL
ko.bindingHandlers.file =
  init: (element, valueAccessor) ->
    $(element).change ->
      file = @files[0]
      valueAccessor() file  if ko.isObservable(valueAccessor())


  update: (element, valueAccessor, allBindingsAccessor) ->
    file = ko.utils.unwrapObservable(valueAccessor())
    bindings = allBindingsAccessor()
    if bindings.fileObjectURL and ko.isObservable(bindings.fileObjectURL)
      oldUrl = bindings.fileObjectURL()
      windowURL.revokeObjectURL oldUrl  if oldUrl
      bindings.fileObjectURL file and windowURL.createObjectURL(file)
    if bindings.fileBinaryData and ko.isObservable(bindings.fileBinaryData)
      unless file
        bindings.fileBinaryData null
      else
        reader = new FileReader()
        reader.onload = (e) ->
          bindings.fileBinaryData e.target.result

        reader.readAsArrayBuffer file