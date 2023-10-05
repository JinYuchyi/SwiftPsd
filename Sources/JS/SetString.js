var defaultRulerUnits = preferences.rulerUnits;
preferences.rulerUnits = Units.PIXELS;
startDisplayDialogs = app.displayDialogs
app.displayDialogs = DialogModes.NO

var stringList = $stringList
var indexList = $indexList

if (indexList.length != stringList.length) {
    alert("String list and index list must have same numbers of element.")
    return
}

for (i = 0; i < indexList; i++) {
    
}
