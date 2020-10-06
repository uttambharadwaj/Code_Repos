window.onload = function() {
    fixElements("input","id");
    fixElements("select","id");
}
function fixAll() {
    fixElements("input","id");
    fixElements("select","id");
}
function fixElements(tagn,attrib)
{
    // Since Salesforce builds a complex Id using the Id's of previous elements, we need
    // to find the one that we want.
    // Note: this means we're searching for tags like:
    // apex:inputfield id="tabIndex4" ....>
    var pat = /:tabIndex[0-9]+/;
    processIdsWithPattern(tagn,attrib,pat);
    processColumnIdsWithPattern(tagn,attrib);
    
}
function processIdsWithPattern(tagn,attrib, pat) {
    var tags = document.getElementsByTagName(tagn);
    var ti;
    var pos;

    for (var i=0; i < tags.length; i++) {
        if (tags[i].getAttribute(attrib) != null){
            pos = tags[i].getAttribute(attrib).search(pat);
            if (pos != -1){
                ti = tags[i].getAttribute(attrib).slice(pos+9);
                tags[i].setAttribute('tabIndex',ti);
            }
        }
    }
}
function processColumnIdsWithPattern(tagn,attrib) {
    var tags = document.getElementsByTagName(tagn);
    var ti;

    for (var i=0; i < tags.length; i++) {

        if (tags[i].getAttribute(attrib) != null){

            ti = getTagIndex(tags[i].getAttribute(attrib));            
        }
        if (ti != null) {
            tags[i].setAttribute('tabIndex',ti);
        }

    }
}
function getTagIndex(attrvalue) {

    var pat = /:colIndex[0-9]+/;
    var startAndRelPos;
    var posOfIndexDef;
    var posOfRow;
    var pos;
    var row;
    var start;
    var columnsPerRow;

    posOfIndexDef = attrvalue.search(pat);
    if (posOfIndexDef == -1){
        return null;
    }
    startAndRelPos = attrvalue.slice(posOfIndexDef+9);
    posOfRow = attrvalue.search(/:[0-9]+:colIndex/);
    if (posOfRow == -1){
        return null;
    }
    rowAndOtherStuff = attrvalue.slice(posOfRow);
    rowAndOtherStuff = rowAndOtherStuff.slice(1);
    posOfColon = rowAndOtherStuff.search(/:/);
    if (posOfColon == -1){
        return null;
    }
    row = rowAndOtherStuff.slice(0,posOfColon);
    pos = startAndRelPos.search(/_/);
    if (pos == -1){
        return null;
    }
    start = startAndRelPos.slice(0,pos);
    startAndRelPos = startAndRelPos.slice(pos+1);
    pos = startAndRelPos.search(/_/);
    if (pos == -1){
        return null;
    }
    col = startAndRelPos.slice(0,pos);
    columnsPerRow = startAndRelPos.slice(pos+1);


    ti = (start*1) + (row*columnsPerRow) + (col * 1);
    return ti;
}




