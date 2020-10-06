$j = jQuery.noConflict();

var validationRan = false;

$j(document).ready(function() {

    pageLoadFunctions();

});

function pageLoadFunctions() {

    $j('.ssn').mask('000-00-0000');
    $j('.date').mask('00/00/0000');
    $j('.dateCanada').mask('0000-00-00');
    $j('.postal').mask('00000-0000');
    $j('.postalCanada').mask('A0A-0A0', {
        translation: {
            'A': {
                pattern: /[A-Za-z]/, optional: false
            }
        }
    });

    $j('[id$=noBeneficialOwners]').on('change', function() {
        if($j(this).is(':checked')) {
            $j('[id$=noOwnerprongs]').val('true');
        }
        else {
            $j('[id$=noOwnerprongs]').val('false');
        }

        rerenderBeneficialOwners();
    });

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

function validatePassport(value) {

    if(value !== "") {

        var characterReg = /^\d*(0123|1234|2345|3456|4567|5678|6789)\d/;
        if(characterReg.test(value)) {
            return false;
        }
        var characterReg1 = /(\d)\1\1+/;
        if(characterReg1.test(value)) {
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

    console.log($Session.Language_Code);
    if(value !== "") {

        var m = null;

        if($Session.Language_Code === "fr_ca") {
            var fecaCharacterReg = /(^\d{4}\-\d{2}\-\d{2}$)/;
            m = moment(value, 'YYYY-MM-DD');
            return m.isValid() && m.isAfter("1900-01-01") && fecaCharacterReg.test(value);
        } else if($Session.Language_Code === "en_ca") {
            var encaCharacterReg = /(^\d{2}\/\d{2}\/\d{4}$)/;
            m = moment(value, 'DD/MM/YYYY');
            return m.isValid() && m.isAfter("1900-01-01") && encaCharacterReg.test(value);
        } else {
            var enusCharacterReg = /(^\d{2}\/\d{2}\/\d{4}$)/;
            m = moment(value, 'MM/DD/YYYY');
            return m.isValid() && m.isAfter("1900-01-01") && enusCharacterReg.test(value);
        }
    }
    return false;
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
    $j('[id$=boForm]').find('.errorFiller').each(function() { $j(this).removeClass('errorFiller'); })

    $j('[id$=boForm]').find('.form-field').each(function() {
        var rowHasError = false;

        $j('[id$=boForm]').find('[data-row=' + $j(this).attr('data-row') + ']').each(function() { if($j(this).find('.fieldErrorMessage').length > 0) { rowHasError = true; } });

        if(rowHasError) {
            $j('[id$=boForm]').find('[data-row=' + $j(this).attr('data-row') + ']').each(function() {
                if($j(this).find('.fieldErrorMessage').length == 0) {
                    $j(this).addClass('errorFiller');
                }
            });
        }
    });
}

function validateForm() {

    $j('[id$=boForm]').find('.erroredInput').each(function() {
        $j(this).removeClass('erroredInput');
    });

    $j('[id$=boForm]').find('.fieldErrorMessage').each(function() {
        $j(this).remove();
    });

    $j('[id$=content]').find('.stepErrors').each(function() {
        $j(this).css('display', 'none');
    });

    $j('[id$=boForm]').find('.erroredSection').each(function() {
        $j(this).removeClass('erroredSection');
    });

    $j('[id$=boForm]').find('.errorFiller').each(function() {
        $j(this).removeClass('errorFiller');
    });

    var hasErrors = false;

    $j('[id$=boForm]').find('.required').each(function() {
        if($j(this).is(":visible") && ($j(this).val() === '' || $j(this).val() === null || $j(this).val() === '#')) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Required + '</div>');

            $j(this).on('click', function() {
                $j(this).removeClass("erroredInput");
                $j(this).next('.fieldErrorMessage').remove();
                levelSetErroredRows();
            });

            hasErrors = true;
        }
    });

    $j('[id$=boForm]').find('.email').each(function() {
        if($j(this).val() != null && !validateEmail($j(this).val())) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Email + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
        }
    });

    $j('[id$=boForm]').find('.phone').each(function() {
        if($j(this).val() != null && !validatePhone($j(this).val())) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Phone + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
        }
    });

    $j('[id$=boForm]').find('.taxpayerId').each(function() {
        if($j(this).val() != null && !validateTaxpayerId($j(this).val())) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Tax_ID + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
        }
    });

    $j('[id$=boForm]').find('.passportNumber').each(function() {
        if($j(this).val() != null && !validatePassport($j(this).val())) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Passport + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
        }
    })

    $j('[id$=boForm]').find('.postal').each(function() {
        if($j(this).val() != null && !validatePostalCode($j(this).val())) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Postal_Code + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
        }
    });

    $j('[id$=boForm]').find('.ssn').each(function() {
        if($j(this).val() != null && !validateSSN($j(this).val())) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_SSN + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
        }
    });

    $j('[id$=boForm]').find('.date, .dateCanada').each(function() {
        if($j(this).val() !== "" && !validateDateOfBirth($j(this).val())) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Date + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
        }
    });

    $j('[id$=boForm]').find('.address').each(function() {
        if($j(this).val() != null && !validatePOBox($j(this).val())) {
            $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_PO_Box_Warning + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
            hasErrors = true;
        }
    });

    if(hasErrors) {
        $j('[id$=errors]').html($Label.BOCA_Application_Errors);
        $j('[id$=errors]').css('display', 'block');

        window.scrollTo(0,0);

        levelSetErroredRows();
    }
    else {

        if(!($j('[id$=acknowledgement]').prop('checked')) && $j('[id$=userSessionId]').val() === "") {
            console.log('missing acknowledgement');
            $j('[id$=errors]').html($Label.BOCA_Acknowledge_Disclaimer + '.');

            hasErrors = true;

            $j('[id$=errors]').css('display', 'block');

            window.scrollTo(0,0);

            levelSetErroredRows();
        }

        if(!hasErrors) {
            $j('[id$=save-button]').addClass('disabled-button');
            $j('[id$=submit-button]').addClass('disabled-button');
            $j('[id$=content]').find('.loader-gif').css('display', 'block');

            submitForm();
        }
    }
}

function scrollIntoView(divId) {

    var offset = $j('[id$=' + divId + ']').offset();

    offset.top -= 20;

    $j('html, body').animate({
        scrollTop: offset.top,
        scrollLeft: offset.left
    })

}