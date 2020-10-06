$j = jQuery.noConflict();

$j(document).ready(function() {

    pageLoadFunctions();

});

function pageLoadFunctions() {

    $j(document).on( 'focus', ':input', function(){
        $j(this).attr('autocomplete', 'something-new');
    });

    $j('.phone').mask('999-999-9999');
    $j('.money').mask('000,000,000,000', {reverse: true});

}

function validate() {

    $j('[id$=partnerBOCAToProspectForm]').parsley({errorClass: 'erroredInput', successClass: '', errorsWrapper: '<div class="fieldErrorMessage"></div>', errorTemplate: '<p class="errorMessage"></p>'}).validate();

    if($j('[id$=partnerBOCAToProspectForm]').parsley().isValid()) {
        $j('body').loadingModal({text: 'Processing', 'animation': 'wanderingCubes'});

        sendApplication();
    }

}
