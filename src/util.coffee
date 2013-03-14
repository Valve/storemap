Array::first = -> @[0]
Array::last = -> @[@.length-1]
Array::empty = -> @.length == 0