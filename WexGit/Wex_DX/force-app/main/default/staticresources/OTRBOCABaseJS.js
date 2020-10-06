$j = jQuery.noConflict();

$j(document).ready(function() {

    pageLoadFunctions();

});

function pageLoadFunctions() {
    $j(document).on( 'focus', ':input', function(){
        $j(this).attr('autocomplete', 'nope');
    });

    var elems = document.querySelectorAll('.required');
    for (var i = 0; i < elems.length; i++) {
        elems[i].required = true;
    }

    $j('.helpIcon').tooltip({
        tooltipClass: 'toolTip',
        position: {my: "left+10 center", at: "right center", collision: "flipfit"},
        content: function (callback) {
            callback($j(this).prop('title').replace(/\|/g, '<br />'));
        }
    });

    $j( "#accordion" ).accordion({ heightStyle: 'content', collapsible: true });

    $j('.numbers').mask("#");
    $j('.phone').mask('999-999-9999');
    $j('.yearEstablished').mask('0000');
    $j('.ssn').mask('000-00-0000');
    $j('.taxpayerId').mask('000000000');
    $j('.date').mask('00/00/0000');
    $j('.postal').mask('00000-0000');
    $j('.postalCanada').mask('A0A-0A0');
    $j('.cpf').mask('999.999.999-99', {reverse: true});
    $j('.money').mask('000,000,000', {reverse: true});
    $j('.prefilledMoney').mask('000,000,000,000.00', {reverse: true});
    $j('.alphaNumeric').mask('ZZ',{translation: {'Z': {pattern: /[a-zA-Z0-9\s]/, recursive: true}}});
    $j('.mcFFDOTNumber').mask('ZZ',{translation: {'Z': {pattern: /[a-zA-Z0-9\s]/, recursive: true}}});

    $j('.limit').mask('0,000', {reverse: true});

    $j("[id$=state] option").eq('').text('--Choose One--');
    $j("[id$=exemptFromMotorFuelsTax] option").eq('').text('--Choose One--');
    $j("[id$=legalStructure] option:contains('--None--')").text('--Choose One--');
    $j("[id$=legalStructure] option:contains('Limited Liability Company')").text('Limited Liability Company (LLC)');
    $j("[id$=fiscalYearStarts ] option").eq('').remove();

    $j("[id$=businessState] option").eq('').text('--Choose One--');
    $j("[id$=paymentMethod] option").eq('').text('--Choose One--');
    $j("[id$=pgState] option").eq('').text('--Choose One--');
    $j("[id$=billingCycle] option").eq('').text('--Choose One--');
    $j("[id$=invoiceDeliveryMethod] option").eq('').text('--Choose One--');
    $j("[id$=title] option").eq('').text('--Choose One--');
    $j("[id$=businessDescription] option").eq('').text('--Choose One--');
    $j("[id$=accountType] option").eq('').text('--Choose One--');

    $j("[id$=yearsInBusiness] option").eq('').text('--Choose One--');
    $j("[id$=yearsInBusiness] option[value='Less than 12 months']").remove();
    $j("[id$=yearsInBusiness] option[value='1']").text('Less than 2 years');

    $j("[id$=creditForm]").find('.step-button').click(function() {
        console.log('here');
        event.preventDefault();
    });

    $j(".check-image").tooltip({ content: '<img src="' + $Label.Check_Sample + '" />' });
}

function reRenderPG() {
    reloadPG();
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

function validateFleetSize(value) {
    if(value !== "") {
        var characterReg = /(^\d{0,6}$)/;
        if(!characterReg.test(value)) {
            return false;
        }
        else if(value === "0") {
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


function validateCanadianPostalCode(value) {
    if(value !== "") {

        var characterReg = /^[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d$/i;
        if(!characterReg.test(value)) {
            return false;
        }
    }
    return true;
}

function validateTaxpayerId(value) {
    if(value !== "") {
        var characterReg = /(^\d{9}$)/;
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
    if(value !== "") {
        var characterReg = /(^\d{2}\/\d{2}\/\d{4}$)/;
        if(!characterReg.test(value)) {
            return false;
        }
    }
    return true;
}

function validateYearEstablished(value) {
    if(value !== "") {

        if(typeof parseInt(value) == 'number' && parseInt(value) >= 1600 && parseInt(value) <= (new Date()).getFullYear()) {

            return true;

        }
        return false;

    }
}

function validatePOBox(value) {
    if(value !== "") {
        var characterReg = /(?:P(?:ost(?:al)?)?[\.\-\s]*(?:(?:O(?:ffice)?[\.\-\s]*)?B(?:ox|in|\b|\d)|o(?:ffice|\b)(?:[-\s]*#*[-\s]*\d)|code)|box[-\s\b]*\d)/i;
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
    $j('[id$=bocaForm]').find('.errorFiller').each(function() { $j(this).removeClass('errorFiller'); })

    $j('[id$=bocaForm]').find('.form-field').each(function() {
        var rowHasError = false;

        $j('[id$=bocaForm]').find('[data-row=' + $j(this).attr('data-row') + ']').each(function() { if($j(this).find('.fieldErrorMessage').length > 0) { rowHasError = true; } });

        if(rowHasError) {
            $j('[id$=bocaForm]').find('[data-row=' + $j(this).attr('data-row') + ']').each(function() {
                if($j(this).find('.fieldErrorMessage').length == 0) {
                    $j(this).addClass('errorFiller');
                }
            });
        }
    });
}

function validateBOCA() {

    $j('[id$=bocaForm]').find('.erroredInput').each(function() {
        $j(this).removeClass('erroredInput');
    });

    $j('[id$=bocaForm]').find('.fieldErrorMessage').each(function() {
        $j(this).remove();
    });

    $j('[id$=content]').find('.stepErrors').each(function() {
        $j(this).css('display', 'none');
    });

    $j('[id$=bocaForm]').find('.erroredSection').each(function() {
        $j(this).removeClass('erroredSection');
    });

    $j('[id$=bocaForm]').find('.errorFiller').each(function() {
        $j(this).removeClass('errorFiller');
    });

    var hasErrors = false;

    $j('[id$=bocaForm]').find('.required').each(function() {
        console.log($j(this).val());
        if($j(this).val() === '' || $j(this).val() === null || $j(this).val() === '#') {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Required + '</div>');

            $j(this).on('click', function() {
                $j(this).removeClass("erroredInput");
                $j(this).next('.fieldErrorMessage').remove();
                levelSetErroredRows();
            });

            hasErrors = true;
        }
    });

    $j('[id$=bocaForm]').find('.email').each(function() {
        this.value = $j(this).val().replace(/\s/g,''); //remove all spaces in the field
        if($j(this).val() != null && !validateEmail($j(this).val())) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Email + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
        }
    });

    $j('[id$=bocaForm]').find('.phone').each(function() {
        if($j(this).val() != null && !validatePhone($j(this).val())) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Phone + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
        }
    });

    $j('[id$=bocaForm]').find('.taxpayerId').each(function() {
        if($j("[id$=taxpayerId]").val() != null && !validateTaxpayerId($j("[id$=taxpayerId]").val())) {
            $j("[id$=taxpayerId]").addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Tax_ID + '</div>');
            $j("[id$=taxpayerId]").on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
        }
    });

    $j('[id$=bocaForm]').find('.postal').each(function() {
        if($j(this).val() != null && !validatePostalCode($j(this).val())) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Postal_Code + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
        }
    });

    $j('[id$=creditForm]').find('.postalCanada').each(function() {
        if($j(this).val() != null && !validateCanadianPostalCode($j(this).val())) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Postal_Code + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
        }
    });

    $j('[id$=bocaForm]').find('.ssn').each(function() {
        if($j(this).val() != null && !validateSSN($j(this).val())) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_SSN + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
        }
    });

    $j('[id$=bocaForm]').find('.date').each(function() {
        if($j(this).val() != null && !validateDateOfBirth($j(this).val())) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Date + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
        }
    });

    $j('[id$=bocaForm]').find('.address').each(function() {
        if($j(this).val() != null && !validatePOBox($j(this).val())) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_PO_Box_Warning + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
        }
    });

    if($j('[id$=yearsInBusiness]').val() !== "" && !validateYearEstablished($j('[id$=yearsInBusiness]').val())) {
        $j('[id$=yearsInBusiness]').addClass('erroredInput').after('<div class="fieldErrorMessage">Please enter a valid year.</div>');
        $j('[id$=yearsInBusiness]').on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
        hasErrors = true;
    }
    
    if($j('[id$=checkingAccountNumber]').length > 0 && $j('[id$=checkingAccountNumber]').val() !== "" && ($j('[id$=checkingAccountNumber]').val().length < 5 || $j('[id$=checkingAccountNumber]').val().length > 14)) {
        $j('[id$=checkingAccountNumber]').addClass('erroredInput').after('<div class="fieldErrorMessage">Please enter a valid checking account number.</div>');
        $j('[id$=checkingAccountNumber]').on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
        hasErrors = true;
    }

    if($j('[id$=verifyCheckingAccountNumber]').length > 0 && $j('[id$=verifyCheckingAccountNumber]').val() !== "" && $j('[id$=checkingAccountNumber]').val() !== $j('[id$=verifyCheckingAccountNumber]').val()) {
        $j('[id$=verifyCheckingAccountNumber]').addClass('erroredInput').after('<div class="fieldErrorMessage">Value does not match checking account number.</div>');
        $j('[id$=verifyCheckingAccountNumber]').on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
        hasErrors = true;
    }

    if($j('[id$=verifyAbaRoutingNumber]').length > 0 && $j('[id$=verifyAbaRoutingNumber]').val() !== "" && $j('[id$=abaRoutingNumber]').val() !== $j('[id$=verifyAbaRoutingNumber]').val()) {
        $j('[id$=verifyAbaRoutingNumber]').addClass('erroredInput').after('<div class="fieldErrorMessage">Value does not match routing number.</div>');
        $j('[id$=verifyAbaRoutingNumber]').on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
        hasErrors = true;
    }

    if($j('[id$=abaRoutingNumber]').length > 0 && $j('[id$=abaRoutingNumber]').val() !== "" && $j('[id$=abaRoutingNumber]').val().length < 9) {
        $j('[id$=abaRoutingNumber]').addClass('erroredInput').after('<div class="fieldErrorMessage">Please enter a valid routing number.</div>');
        $j('[id$=abaRoutingNumber]').on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
        hasErrors = true;
    }

    if($j('[id$=pgSSN]').length > 0 && $j('[id$=pgSSN]').val() !== $j('[id$=verifyPgSSN]').val()) {
        $j('[id$=verifyPgSSN]').addClass('erroredInput').after('<div class="fieldErrorMessage">Value does not match Social Security #.</div>');
        $j('[id$=verifyPgSSN]').on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
        hasErrors = true;
    }

    if(hasErrors) {
        $j('[id$=errors]').html('Your form has errors. Please fill in all required fields.');
        $j('[id$=errors]').css('display', 'block');

        window.scrollTo(0,0);

        levelSetErroredRows();
    }
    else {

        if(!($j('[id$=acknowledgeDisclaimer]').prop('checked')) && $j('[id$=userSessionId]').val() === "") {
            $j('[id$=disclaimerErrors]').css('display', 'block');

            $j('[id$=authorizedSignerBody]').addClass('erroredSection');

            document.querySelector("#disclaimerErrors").scrollIntoView();

            hasErrors = true;
        }

        if(!hasErrors) {
            $j('[id$=saveButton]').addClass('disabled-button');
            $j('[id$=submitButton]').addClass('disabled-button');
            $j('[id$=content]').find('.loader-gif').css('display', 'block');

            submitApplication();
        }
    }
}

function validateAndSaveBOCA() {

    $j('[id$=bocaForm]').find('.erroredInput').each(function() {
        $j(this).removeClass('erroredInput');
    });

    $j('[id$=bocaForm]').find('.fieldErrorMessage').each(function() {
        $j(this).remove();
    });

    $j('[id$=content]').find('.stepErrors').each(function() {
        $j(this).css('display', 'none');
    });

    $j('[id$=bocaForm]').find('.erroredSection').each(function() {
        $j(this).removeClass('erroredSection');
    });

    $j('[id$=bocaForm]').find('.errorFiller').each(function() {
        $j(this).removeClass('errorFiller');
    });

    var hasErrors = false;

    $j('[id$=bocaForm]').find('.email').each(function() {
        if($j(this).val() != null && !validateEmail($j(this).val())) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Email + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
            console.log('# HIT');
        }
    });

    $j('[id$=bocaForm]').find('.phone').each(function() {
        if($j(this).val() != null && !validatePhone($j(this).val())) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Phone + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
            console.log('# HIT');
        }
    });

    $j('[id$=bocaForm]').find('.taxpayerId').each(function() {
        if($j(this).val() != null && !validateTaxpayerId($j(this).val())) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Tax_ID + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
            console.log('# HIT');
        }
    });

    $j('[id$=bocaForm]').find('.postal').each(function() {
        if($j(this).val() != null && !validatePostalCode($j(this).val())) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Postal_Code + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
            console.log('# HIT');
        }
    });

    $j('[id$=bocaForm]').find('.ssn').each(function() {
        if($j(this).val() != null && !validateSSN($j(this).val())) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_SSN + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
            console.log('# HIT');
        }
    });

    $j('[id$=bocaForm]').find('.date').each(function() {
        if($j(this).val() != null && !validateDateOfBirth($j(this).val())) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Date + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
            console.log('# HIT');
        }
    });

    $j('[id$=bocaForm]').find('.address').each(function() {
        if($j(this).val() != null && !validatePOBox($j(this).val())) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_PO_Box_Warning + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
            console.log('# HIT');
        }
    });

    if($j('[id$=emailAddress]').val() == null || $j('[id$=emailAddress]').val() === '') {
        $j('[id$=emailAddress]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Required + '</div>');
        $j('[id$=emailAddress]').on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
        hasErrors = true;
        console.log('# HIT');
    }

    if($j('[id$=firstName]').val() == null || $j('[id$=firstName]').val() === '') {
        $j('[id$=firstName]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Required + '</div>');
        $j('[id$=firstName]').on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
        hasErrors = true;
        console.log('# HIT');
    }

    if($j('[id$=lastName]').val() == null || $j('[id$=lastName]').val() === '') {
        $j('[id$=lastName]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Required + '</div>');
        $j('[id$=lastName]').on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
        hasErrors = true;
        console.log('# HIT');
    }

    console.log('###' + $j('[id$=checkingAccountNumber]').val() + ' ' + $j('[id$=verifyCheckingAccountNumber]').val());

    if($j('[id$=checkingAccountNumber]').val() !== $j('[id$=verifyCheckingAccountNumber]').val()) {
        $j('[id$=verifyCheckingAccountNumber]').addClass('erroredInput').after('<div class="fieldErrorMessage">Value does not match checking account number.</div>');
        $j('[id$=verifyCheckingAccountNumber]').on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
        hasErrors = true;
        console.log('# HIT');
    }

    console.log('###' + $j('[id$=abaRoutingNumber]').val() + ' ' + $j('[id$=verifyAbaRoutingNumber]').val());

    if($j('[id$=abaRoutingNumber]').val() !== $j('[id$=verifyAbaRoutingNumber]').val()) {
        $j('[id$=verifyAbaRoutingNumber]').addClass('erroredInput').after('<div class="fieldErrorMessage">Value does not match routing number.</div>');
        $j('[id$=verifyAbaRoutingNumber]').on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
        hasErrors = true;
        console.log('# HIT');
    }

    if(hasErrors) {
        $j('[id$=errors]').html('Your form has errors. Please fix them before saving.');
        $j('[id$=errors]').css('display', 'block');

        window.scrollTo(0,0);

        levelSetErroredRows();
    }
    else {

        if(!hasErrors) {
            $j('[id$=submitButton]').addClass('disabled-button');
            $j('[id$=saveButton]').addClass('disabled-button');
            $j('[id$=content]').find('.loader-gif').css('display', 'block');

            saveApplication();
        }
    }
}

function validateFinancialsForm() {

    console.log('requireFinancials:' + requireFinancials);
    console.log('areRequiredDocumentsUploaded:' + areRequiredDocumentsUploaded);

    $j('[id$=creditForm]').find('.erroredInput').each(function() {
        $j(this).removeClass('erroredInput');
    });

    $j('[id$=bocaForm]').find('.fieldErrorMessage').each(function() {
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


    var hasErrors = false;

    $j('[id$=creditForm]').find('.required').each(function() {
        console.log($j(this).val());
        if($j(this).val() === '' || $j(this).val() === null || $j(this).val() === '#' || $j(this).val() === '--Choose One--') {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Required + '</div>');

            $j(this).on('click', function() {
                $j(this).removeClass("erroredInput");
                $j(this).removeClass("fieldErrorMessage");
            });

            hasErrors = true;
        }
    });


    if (requireFinancials && !areRequiredDocumentsUploaded) {
        console.log('Required documents are not attached to the application.');
        hasErrors = true;
    }

    console.log('hasErrors: ' + hasErrors);

    if(hasErrors) {
        $j('[id$=errors]').html('Your form has errors. Please fill in all required fields and attach all requested documents.');
        $j('[id$=errors]').css('display', 'block');

        window.scrollTo(0,0);

        levelSetErroredRows();
    }
    else {
        $j('[id$=submitButton]').addClass('disabled-button');
        $j('[id$=content]').find('.loader-gif').css('display', 'block');

        console.log('submitting');

        submitApplication();
    }
}

function validateFleetForm() {

    $j('[id$=bocaForm]').find('.erroredInput').each(function() {
        $j(this).removeClass('erroredInput');
    });

    $j('[id$=bocaForm]').find('.fieldErrorMessage').each(function() {
        $j(this).remove();
    });

    $j('[id$=content]').find('.stepErrors').each(function() {
        $j(this).css('display', 'none');
    });

    $j('[id$=bocaForm]').find('.erroredSection').each(function() {
        $j(this).removeClass('erroredSection');
    });

    $j('[id$=bocaForm]').find('.errorFiller').each(function() {
        $j(this).removeClass('errorFiller');
    });

    var hasErrors = false;

    $j('[id$=bocaForm]').find('.required').each(function() {
        console.log($j(this).val());
        if($j(this).val() === '' || $j(this).val() === null || $j(this).val() === '#') {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Required + '</div>');

            $j(this).on('click', function() {
                $j(this).removeClass("erroredInput");
                $j(this).removeClass("fieldErrorMessage");
            });

            hasErrors = true;
        }
    });

    $j('[id$=bocaForm]').find('.email').each(function() {
        if($j(this).val() != null && !validateEmail($j(this).val())) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Email + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
        }
    });

    $j('[id$=bocaForm]').find('.phone').each(function() {
        if($j(this).val() != null && !validatePhone($j(this).val())) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Phone + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
        }
    });

    $j('[id$=bocaForm]').find('.postal').each(function() {
        if($j(this).val() != null && !validatePostalCode($j(this).val())) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Postal_Code + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
        }
    });

    $j('[id$=bocaForm]').find('.address').each(function() {
        if($j(this).val() != null && !validatePOBox($j(this).val())) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_PO_Box_Warning + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
        }
    });

    console.log(hasErrors);

    if(hasErrors) {
        $j('[id$=errors]').html('Your form has errors. Please fill in all required fields.');
        $j('[id$=errors]').css('display', 'block');

        window.scrollTo(0,0);

        levelSetErroredRows();
    }
    else {
        $j('[id$=submitButton]').addClass('disabled-button');
        $j('[id$=content]').find('.loader-gif').css('display', 'block');

        console.log('submitting');

        submitForm();
    }
}

var selectedFundingOptions = [];

function changeSelectedFunOptions(field) {
    const index = selectedFundingOptions.indexOf(field.value);
    if (field.checked && index < 0) {
        selectedFundingOptions.push(field.value);
    } else if (!field.checked) {
        const index = selectedFundingOptions.indexOf(field.value);
        if (index > -1) {
            selectedFundingOptions.splice(index, 1);
        }
    }
    $j("[id$=selectedFundingOptionsValue]").val(selectedFundingOptions);
    console.log(selectedFundingOptions);
}

function scrollIntoView(divId) {

    var offset = $j('[id$=' + divId + ']').offset();

    offset.top -= 20;

    $j('html, body').animate({
        scrollTop: offset.top,
        scrollLeft: offset.left
    });
}

//all selected merch...for Allowed Merchant Categories
var mySelectedMerch = [];

//one of the merchant options was clicked! add/remove it from the list!
function merchSelection(myField){
    const myIndex = mySelectedMerch.indexOf(myField.value);
    if(myField.checked && myIndex < 0){
        mySelectedMerch.push(myField.value);
    } else if(!myField.checked) {
        deselectThisMerch(myField.value);
        $j("[id$=allFuel]").prop('checked', false);
        removeAllMerch();
    }
    $j("[id$=selectedMerchValue]").val(mySelectedMerch);
}

//removes an entry from mySelectedMerch list
function deselectThisMerch(myMerch){
    const myIndex = mySelectedMerch.indexOf(myMerch);
    if(myIndex > -1){
        mySelectedMerch.splice(myIndex,1);
    }
}

//deselects and removes the all merchant option
function removeAllMerch(){
    deselectThisMerch('All Merchants');
    $j("[id$=allMerch]").prop('checked', false);
}

//select all the fuel options. or deselect. whichever.
function allFuelSelect(myField){
    if(myField.checked){
        $j("[name=myMerch]").each(function(){
            this.checked=true;
            merchSelection(this);
        });
    } else {
        $j("[name=myMerch]").each(function(){
            this.checked=false;
            merchSelection(this);
        });
    }
}

//select all merchants and fuel categories
function allMerchants(myField){
    if(myField.checked){
        mySelectedMerch.push('All Merchants');
        $j("[name=myMerch]").each(function(){
            this.checked=true;
            merchSelection(this);
        });
        $j("[name=allTheFuel]").prop('checked',true);
    } else {
        $j("[name=myMerch]").each(function(){
            this.checked=false;
            merchSelection(this);
        });
        $j("[name=allTheFuel]").prop('checked',false);
    }
}

var selectedProducts = [];
function prodSelection(myProduct){
    const myIndex = selectedProducts.indexOf(myProduct.value);
    if(myProduct.checked && myIndex < 0){
        selectedProducts.push(myProduct.value);
    } else if(!myProduct.checked) {
        selectedProducts.splice(myIndex,1);
    }
    $j("[id$=selectedOtherServicesValue]").val(selectedProducts);
    //if(selectedProducts.length > 0) $j("[id$=transferOptions]").show();
    //else $j("[id$=transferOptions]").hide();
    if(selectedProducts.join(";").includes('MasterCard')) {
        $j("[id$=allowedMerchantCategories]").show();
    } else {
        $j("[id$=allowedMerchantCategories]").hide();
    }
}
