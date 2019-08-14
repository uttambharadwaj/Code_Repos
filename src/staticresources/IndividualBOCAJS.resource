$j = jQuery.noConflict();

$j(document).ready(function() {

    pageLoadFunctions();

});

function pageLoadFunctions() {
    $j(document).on( 'focus', ':input', function(){
        $j(this).attr('autocomplete', 'nope');
    });

    $j('.helpIcon').tooltip({
        tooltipClass: 'toolTip',
        position: { my: "left+10 center", at: "right center", collision: "flipfit" },
    });

    $j( "#accordion" ).accordion({ heightStyle: 'content', collapsible: true });

    flipToProvince('state');
    flipToProvince('pgState');
    flipToProvince('billingState');

    $j(".postal").each(function() {
        $j(this).addClass('postalCanada').removeClass('postal');
    });

    $j('.phone').mask('999-999-9999');
    $j('.ssn').mask('000-00-0000');
    $j('.date').mask('00/00/0000');
    $j('.dateFRCA').mask('0000-00-00');
    $j('.postal').mask('00000-0000');
    $j('.postalCanada').mask('A0A-0A0');
    $j('.cpf').mask('999.999.999-99', {reverse: true});
    $j('.money').mask('000,000,000,000', {reverse: true});
    $j('.prefilledMoney').mask('000,000,000,000', {reverse: true});
    $j('.dunsNumber').mask('000000000');

    // Fixing a load of picklist options
    $j("[id$=yearsInBusiness] option").eq('').text($Label.BOCA_Picklist_Choose_One);
    $j("[id$=state] option").eq('').text($Label.BOCA_Picklist_Choose_One);
    $j("[id$=pgState] option").eq('').text($Label.BOCA_Picklist_Choose_One);
    $j("[id$=billingState] option").eq('').text($Label.BOCA_Picklist_Choose_One);
    $j("[id$=exemptFromMotorFuelsTax] option").eq('').text($Label.BOCA_Picklist_Choose_One);
    $j("[id$=legalStructure] option").eq('').text($Label.BOCA_Picklist_Choose_One);
    $j("[id$=fiscalYearStarts] option[value='']").remove();
    $j("[id$=communicationPreference] option[value='']").remove();
    $j("[id$=cardUsageType] option[value='']").remove();

    $j("[id$=creditForm]").find('.step-button').click(function() {
        console.log('here');
        event.preventDefault();
    });

    if(page_name === 'App-Page1' || page_name === 'App-Page1-Errors') {
        $j('[id$=pgnote]').css('display', 'none');
    }
    else {
        $j('[id$=pgnote]').css('display', 'block');
    }

    console.log($Session.Language_Code);

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

function validatePhone(value) {
    if(value !== "") {
        var characterReg = /\(?([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{4})/;
        if(!characterReg.test(value)) {
            return false;
        }
    }
    return true;
}

function validateEmail(value) {
    console.log(value);
    if(value) {
        var characterReg = /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i;
        if(!characterReg.test(value)) {
            return false;
        }
    }
    return true;
}

function validateCanadianPostalCode(value) {
    if(value !== "") {

        var characterReg = /^[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d$/i;
        if(!characterReg.test(value)) {
            return false;
        }
    }
    return true;
}

function validatePostalCode(value) {
    if(value !== "") {
        var characterReg = /(^\d{5}$)|(^\d{5}-\d{4}$)/;
        if(!characterReg.test(value)) {
            return false;
        }
    }
    return true;
}

function validateSSN(value) {
    if(value !== "") {
        var characterReg = /(^\d{3}-\d{2}-\d{4}$)/;
        if(!characterReg.test(value)) {
            return false;
        }
    }
    return true;
}

function validateDateOfBirth(value) {
    console.log($Session.Language_Code);
    if(value !== "") {

        var m = null;

        if($Session.Language_Code === "fr_ca") {
            m = moment(value, 'YYYY-MM-DD');
            return m.isValid() && m.isAfter("1900-01-01");
        }
        if($Session.Language_Code === "en_ca") {
            m = moment(value, 'DD/MM/YYYY');
            return m.isValid() && m.isAfter("1900-01-01");
        }
        else {
            m = moment(value, 'MM/DD/YYYY');
            return m.isValid() && m.isAfter("1900-01-01");
        }
    }
    return false;
}

function validatePOBox(value) {
    if(value !== "") {
        var characterReg = /\bP(ost|ostal)?([ \.]*(O|0)(ffice)?)?([ \.]*Box)?\b/i;;
        console.log(characterReg.test(value));
        if(characterReg.test(value)) {
            return false;
        }
    }
    return true;
}

// Due to the design of the form (two column, left to right), this function was created
// to make the rows even if the sister field has an error. Basically add padding.
function levelSetErroredRows() {
    $j('[id$=creditForm]').find('.form-field').each(function() {
        var rowHasError = false;

        $j('[id$=creditForm]').find('[data-row=' + $j(this).attr('data-row') + ']').each(function() { if($j(this).find('.fieldErrorMessage').length > 0) { rowHasError = true; } });

        if(rowHasError) {
            $j('[id$=creditForm]').find('[data-row=' + $j(this).attr('data-row') + ']').each(function() {
                if($j(this).find('.fieldErrorMessage').length == 0) {
                    $j(this).addClass('errorFiller');
                }
            });
        }
    });
}

function validate() {

    var errorCount = 0;

    $j('[id$=creditForm]').find('.erroredInput').each(function() {
        $j(this).removeClass('erroredInput');
    });

    $j('[id$=creditForm]').find('.fieldErrorMessage').each(function() {
        $j(this).remove();
    });

    $j('[id$=content]').find('.stepErrors').each(function() {
        $j(this).css('display', 'none');
    });

    $j('[id$=creditForm]').find('.erroredSection').each(function() {
        $j(this).removeClass('erroredSection');
    });

    $j('[id$=creditForm]').find('.errorFiller').each(function() {
        $j(this).removeClass('errorFiller');
    });

    $j('[id$=creditForm]').find('.required').each(function() {
        if($j(this).val() === "" || !($j(this).val()).replace(/\s/g, '').length) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Required + '</div>'); errorCount++;
        }
    });

    if(($j('[id$=email]').val()).replace(/\s/g, '').length > 0 && !validateEmail($j('[id$=email]').val())) {
        $j('[id$=email]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Email + '</div>'); errorCount++;
    }

    if(($j('[id$=phone]').val()).replace(/\s/g, '').length > 0 && $j('[id$=phone]').val() != null && !validatePhone($j('[id$=phone]').val())) {
        $j('[id$=phone]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Phone + '</div>'); errorCount++;
    }

    if(($j('[id$=mobilePhone]').val()).replace(/\s/g, '').length > 0 && $j('[id$=mobilePhone]').val() != null && !validatePhone($j('[id$=mobilePhone]').val())) {
        $j('[id$=mobilePhone]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Phone + '</div>'); errorCount++;
    }

    if(($j('[id$=sin]').val()).replace(/\s/g, '').length > 0 && $j('[id$=sin]').val() !== "" && !validateSSN($j('[id$=sin]').val())) {
        $j('[id$=sin]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_SSN + '</div>'); errorCount++;
    }

    if(($j('[id$=dateOfBirth]').val()).replace(/\s/g, '').length > 0 && $j('[id$=dateOfBirth]').val() !== "" && !validateDateOfBirth($j('[id$=dateOfBirth]').val())) {
        $j('[id$=dateOfBirth]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Date + '</div>'); errorCount++;
    }

    if(($j('[id$=addressLine1]').val()).replace(/\s/g, '').length > 0 && $j('[id$=addressLine1]').val() != null && !validatePOBox($j('[id$=billingAddress1]').val())) {
        $j('[id$=addressLine1]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_PO_Box_Warning + '</div>'); errorCount++;
    }

    if($Session.Language_Code === "en_ca" || $Session.Language_Code === "fr_ca") {
        if(($j('[id$=postalCode]').val()).replace(/\s/g, '').length > 0 && $j('[id$=postalCode]').val() != null && $j('[id$=postalCode]').val() !== "" && !validateCanadianPostalCode($j('[id$=postalCode]').val())) {
            $j('[id$=postalCode]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Postal_Code + '</div>'); errorCount++;
        }
    }
    else {
        if(($j('[id$=postalCode]').val()).replace(/\s/g, '').length > 0 && $j('[id$=postalCode]').val() != null && $j('[id$=postalCode]').val() !== "" && !validatePostalCode($j('[id$=postalCode]').val())) {
            $j('[id$=postalCode]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Postal_Code + '</div>'); errorCount++;
        }
    }

    if(($j('[id$=averageMonthlyFuelExpenses]').val()).replace(/\s/g, '').length > 0 && $j('[id$=averageMonthlyFuelExpenses]').val() !== "" && !(parseFloat($j('[id$=averageMonthlyFuelExpenses]').val().replace(/,/g,'')) > 0)) {
        $j('[id$=averageMonthlyFuelExpenses]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Amount + '</div>'); errorCount++;
    }

    if(($j('[id$=estimatedFuelVolume]').val()).replace(/\s/g, '').length > 0 && $j('[id$=estimatedFuelVolume]').val() != null && $j('[id$=estimatedFuelVolume]').val() !== "" && !(parseFloat($j('[id$=estimatedFuelVolume]').val().replace(/,/g,'')) > 0)) {
        $j('[id$=estimatedFuelVolume]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Amount + '</div>'); errorCount++;
    }

    if(errorCount == 0 && !($j('[id$=acknowledgeDisclaimer]').prop('checked'))) {
        $j('[id$=disclaimerErrors]').css('display', 'block');

        $j('[id$=authorizedSignerBody]').addClass('erroredSection');

        window.page_name = "App-Page2-Errors";

        document.querySelector("#disclaimerErrors").scrollIntoView();

        errorCount++;
    }
    else if(errorCount == 0) {
        $j('[id$=creditForm]').find('.step-button').addClass('disabled-button');
        $j('[id$=creditForm]').find('.loader-gif').css('display', 'block');
        submitApplication();
    }
    else {
        $j('[id$=errors]').css('display', 'block');

        levelSetErroredRows();

        window.page_name = "App-Page1-Errors";

        if(typeof dataLayer !== 'undefined') {
            dataLayer.push({'event': 'sfdcapp_page_rerendered'});
        }
        document.querySelector("#errors").scrollIntoView();
    }

}