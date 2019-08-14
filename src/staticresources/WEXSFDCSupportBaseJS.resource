$j = jQuery.noConflict();

$j(document).ready(function() {

pageLoadFunctions();

});

function pageLoadFunctions() {

    overridePageMessages();

}

function overridePageMessages() {
    var textureEffect = '';

    $j('.warningM3').addClass('warningMessage');
    $j('.confirmM3').addClass('confirmMessage');
    $j('.errorM3').addClass('errorMessage');
    $j('.infoM3').addClass('infoMessage');

    $j('.errorM3').removeClass('errorM3');
    $j('.confirmM3').removeClass('confirmM3');
    $j('.infoM3').removeClass('infoM3');
    $j('.warningM3').removeClass('warningM3');
}

function validate() {

    $j('[id$=newCaseForm]').parsley({excluded: ':hidden'}).validate();

    if($j('[id$=newCaseForm]').parsley().isValid()) {

        stepContinue();

    }


    
}

function clickCreate() {

    $j('[id$=newCaseForm]').parsley({excluded: ':hidden'}).validate();

    if($j('[id$=newCaseForm]').parsley().isValid()) {

        submitCase();

    }
}
