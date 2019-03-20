$j = jQuery.noConflict();

$j(document).ready(function() {

    pageLoadFunctions();

    document.cookie = "debug_logs=debug_logs;domain=.force.com";

    //$j.exitIntent('enable');

    $j(document).bind('exitintent', function() {
        $j('[id$=exitIntent]').modal('show');
    });

    //$j('[id$=exitIntent]').on('hidden.bs.modal', function () {
        //$j.exitIntent('disable');
    //})

});

function pageLoadFunctions() {

    document.querySelector("#header").scrollIntoView();

    $j('.phone').mask('999-999-9999');
    $j('.postal').mask('00000-0000');
    $j('.postalCanada').mask('A0A-0A0');
    //$j('.tin').mask('000000000');
    $j('.date').mask('99/99/9999');
    
    $j('[id$=taxpayerId]').removeAttr('data-parsley-type');

    flipToProvince('physicalState');
    flipToProvince('mailingState');

    $j("[id$=bpavEvidence]").on('change', function() {
        var filename = $j(this).val();
        filename = filename.replace(/.*[\/\\]/, '');
        $j("[id$=bpavEvidenceFilename]").val(filename);
        $j("[id$=visibleFileName]").val(filename);
    });

    $j(window).on('beforeunload', function(){
        console.log("beforeUnload event!");
    });

    $j(document).on( 'focus', ':input', function(){
        $j(this).attr('autocomplete', 'nope');
    });

    $j("input[name=verification]").on('change', function() {
        $j("[id$=bpavMethod]").val($j(this).val());

        console.log($j("[id$=bpavMethod]").val());

        $j('[id$=uploadFileGroup]').removeClass('erroredInput');
        $j('[id$=uploadFileGroup]').next('.fieldErrorMessage').remove();
    });

    $j("[id$=mailingAddressSameCheckbox]").on('change', function() {

        console.log($j("[id$=mailingAddressSame]").val());

        if($j("[id$=mailingAddressSame]").val() === "true") { $j("[id$=mailingAddressSame]").val("false"); $j("[id$=mailingAddress]").css('display', 'block');

            $j("[id$=mailingAddress]").find('input').each(function() {
                $j(this).val('');
            });
        }
        else {
            $j("[id$=mailingAddressSame]").val("true"); $j("[id$=mailingAddress]").css('display', 'none');

            $j("[id$=mailingAddressLine1]").val($j("[id$=physicalAddressLine1]").val());
            $j("[id$=mailingAddressLine2]").val($j("[id$=physicalAddressLine2]").val());
            $j("[id$=mailingCity]").val($j("[id$=physicalCity]").val());
            $j("[id$=mailingState]").val($j("[id$=physicalState]").val());
            $j("[id$=mailingPostalCode]").val($j("[id$=physicalPostalCode]").val());
        }

    });

}

function flipToProvince(id) {

    var provinces = ['AB','BC','MB','NB','NL','NS','NT','NU','ON','PE','QC','SK','YT'];

    $j("[id$=" + id + "] option").each(function() {
        if($j(this).val() !== '' && $j.inArray($j(this).val(), provinces) == -1) {
            $j(this).remove();
        }
    });

    var currentValues = new Array();

    $j("[id$=" + id + "] option").each(function() {
        currentValues.push($j(this).val());
    });

    console.log(currentValues);

    for(var i = 0; i < provinces.length; i++) {
        if($j.inArray(provinces[i], currentValues) == -1) {
            $j("[id$=" + id + "]").append($j('<option>', { value: provinces[i], text: provinces[i] }));
        }
    }

}

function validate() {

    $j('[id$=conversionForm]').parsley({errorClass: 'erroredInput', successClass: '', errorsWrapper: '<div class="fieldErrorMessage"></div>', errorTemplate: '<p class="errorMessage"></p>'}).validate();

    if($j('[id$=conversionForm]').parsley().isValid()) {
        nextStep();
    }

}

function submitForm() {

    $j('[id$=conversionForm]').parsley({errorClass: 'erroredInput', successClass: '', errorsWrapper: '<div class="fieldErrorMessage"></div>', errorTemplate: '<p class="errorMessage"></p>'}).validate();

    $j('[id$=uploadFileGroup]').removeClass('erroredInput');
    $j('[id$=uploadFileGroup]').next('.fieldErrorMessage').remove();

    if($j('[id$=bpavMethod]').val() != null && $j('[id$=bpavMethod]').val() === 'Upload' && $j('[id$=visibleFileName]').val() === "") {

        $j('[id$=uploadFileGroup]').addClass('erroredInput').after('<div class="fieldErrorMessage filled" style="padding-top: 3px; padding-bottom: 3px;">Required</div>');

        $j('[id$=uploadFileGroup]').on('click', function() {
            $j(this).removeClass('erroredInput');
            $j(this).next('.fieldErrorMessage').remove();
        });

    }
    else {

        if($j('[id$=conversionForm]').parsley().isValid()) {
            submitConversionForm();
        }

    }

}

function triggerFileBrowse() {
    $j('[id$=bpavEvidence]').click();
}

function getParameterByName(name) {
    
		name = name.replace(/[\[\]]/g, "\\$&");
    
        var url = window.location.href;
        
        var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)");
        
        var results = regex.exec(url);
        
        if (!results) return null;
        
        if (!results[2]) return '';
        
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    
}

function validatePreviousAccountNumber() {
    
    console.log(getParameterByName('lang'));
    
    $j('[id$=previousAccountNumber]').removeClass('erroredInput');
    $j('[id$=previousAccountNumber]').parent().find('.fieldErrorMessage').each(function() { $j(this).remove() });

    $j('[id$=conversionForm]').parsley({errorClass: 'erroredInput', successClass: '', errorsWrapper: '<div class="fieldErrorMessage"></div>', errorTemplate: '<p class="errorMessage"></p>'}).validate();

    if($j('[id$=conversionForm]').parsley().isValid()) {

        var previousAccountNumberQuery = $j('[id$=previousAccountNumber]').val();

        var programId = $j('[id$=programId]').val();

        Visualforce.remoting.Manager.invokeAction(
            'ESSOConversionController.validatePreviousAccountNumber',
            previousAccountNumberQuery,
            function(result, event){
                console.log(result);
                console.log(event);
                if (event.status) {
                    if(result == true) {
                        console.log("here -calling next step");
                        nextStep();
                    }
                    else {
                        if(getParameterByName('lang') === 'fr_ca') {
                            $j('[id$=previousAccountNumber]').addClass('erroredInput').after('<div class="fieldErrorMessage filled" style="padding-top: 3px; padding-bottom: 3px;">Veuillez entrer un num&eacute;ro de client &agrave; 10 chiffres.</div>');
                        }
                        else {
                        	$j('[id$=previousAccountNumber]').addClass('erroredInput').after('<div class="fieldErrorMessage filled" style="padding-top: 3px; padding-bottom: 3px;">Please enter a valid 10-digit customer number.</div>');
                        }

                        $j('[id$=previousAccountNumber]').on('click', function() {
                            $j(this).removeClass("erroredInput");
                            $j(this).next('.fieldErrorMessage').remove();
                        });
                    }
                } else if (event.type === 'exception') {
                    console.log(result);
                    console.log(event);
                } else {
                    console.log(result);
                    console.log(event);
                }
            },
            {escape: true}
        );



    }
}