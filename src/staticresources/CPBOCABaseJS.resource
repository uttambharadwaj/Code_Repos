$j = jQuery.noConflict(); 

var isNA = true;

$j(document).ready(function() {
    
    pageLoadFunctions();
    
});

function pageLoadFunctions() {

    $j(document).on( 'focus', ':input', function(){
        $j(this).attr('autocomplete', 'something-new');
    });
    
    $j('.helpIcon').tooltip({
        tooltipClass: 'toolTip', 
        position: { my: "left+10 center", at: "right center", collision: "flipfit" },
    });
    
    $j( "#accordion" ).accordion({ heightStyle: 'content', collapsible: true });
    
    // Various transformations for the Canadian application
    if(boca_language_code === "en_ca" || boca_language_code === "fr_ca") {
        flipToProvince('state');
        flipToProvince('pgState');
        flipToProvince('billingState');
        
        $j("[id$=legalStructure] option[value='Limited Liability Company']").remove();
        $j("[id$=legalStructure] option[value='Corporation/Association']").remove();
        
        $j(".postal").each(function() {
            $j(this).addClass('postalCanada').removeClass('postal');
        });
    }
    else {
        $j("[id$=legalStructure] option[value='Government']").remove();
        $j("[id$=legalStructure] option[value='Religious']").remove();
        $j("[id$=legalStructure] option[value='Other']").remove();
    }

    $j('.ssn').mask('000-00-0000');
    $j('.date').mask('00/00/0000');
    $j('.cpf').mask('999.999.999-99', {reverse: true});
    $j('.money').mask('000,000,000', {reverse: true});
    $j('.prefilledMoney').mask('000,000,000,000', {reverse: true});
    $j('.dunsNumber').mask('000000000');
    $j('.taxPayerId').mask('000000000');
    $j('.yearsInBusiness').mask('000');

    const myCountry = $j("[id$=physicalCountry]").val();
    if(myCountry === 'US' || myCountry === 'CA') isNA = true;
    else isNA = false;

    const myPhone = $j("[id$=phone]").val();
    const bankPhone = $j("[id$=bankContactPhone]").val();
    const myPostl = $j('.postal').val();

    //some stuff just for US/CAN at the moment
    if(isNA){
        $j('.phone').mask('999-999-9999');
        $j('.postal').mask('00000-0000');
        $j('.postalCanada').mask('A0A-0A0');

        if(myPhone == null || myPhone === '') {
            $j("[id$=phone]").attr('placeholder',$Label.BOCA_Placeholder_Phone);
        }

        if(bankPhone == null || bankPhone === '') {
            $j("[id$=bankContactPhone]").attr('placeholder',$Label.BOCA_Placeholder_Phone)
        }

        if(myPostl == null){
            $j('.postal').attr('placeholder',$Label.BOCA_Placeholder_Postal_Code);
            $j('.postalCanada').attr('placeholder',$Label.BOCA_Placeholder_Postal_Code);
        }

    } else {
        $j('.phone').unmask();
        $j('.postal').unmask();
        $j('.postalCanada').unmask();
        $j('.phone').attr('maxlength',20);

        if(myPhone == null || myPhone === '') {
            $j("[id$=phone]").removeAttr('placeholder');
        }

        if(bankPhone == null || bankPhone === '') {
            $j("[id$=bankContactPhone]").removeAttr('placeholder'); 
        }

        if(myPostl == null){
            $j('.postal').removeAttr('placeholder');
            $j('.postalCanada').removeAttr('placeholder');
        }

    }

    const myMoney = $j('.money').val();
    if(myMoney == null || myMoney === ''){
        const myCurrency = $j("[id$=preferredCurrency]").val();
        if(myCurrency === 'USD' || myCurrency === 'CAD')
            $j('.money').attr('placeholder','$');
        else
            $j('.money').removeAttr('placeholder');
    }

    // Fixing a load of picklist options
    $j("[id$=yearsInBusiness] option").eq('').text($Label.BOCA_Picklist_Choose_One);
    $j("[id$=physicalState] option").eq('').text($Label.BOCA_Picklist_Choose_One);
    $j("[id$=guarantorState] option").eq('').text($Label.BOCA_Picklist_Choose_One);
    $j("[id$=billingState] option").eq('').text($Label.BOCA_Picklist_Choose_One);
    $j("[id$=exemptFromMotorFuelsTax] option").eq('').text($Label.BOCA_Picklist_Choose_One);
    $j("[id$=legalStructure] option").eq('').text($Label.BOCA_Picklist_Choose_One);
    $j("[id$=physicalCounty] option").eq('').text($Label.BOCA_Picklist_Choose_One);
    $j("[id$=mailingCounty] option").eq('').text($Label.BOCA_Picklist_Choose_One);
    $j("[id$=fiscalYearStarts] option[value='']").remove();
    $j("[id$=communicationPreference] option[value='']").remove();
    $j("[id$=cardUsageType] option[value='']").remove();

    $j(".check-image").tooltip({ content: '<img src="' + $Label.Check_Sample + '" />' });
    
    if(card_program_name === 'SunocoGettUniversal') {
        
        $j("[id$=companyName]").attr('placeholder', 'Enter GETT and your First and Last Name');
        $j("[id$=doingBusinessAs]").addClass('required').attr('placeholder', 'Enter your GETT Driver ID');
        $j("[id$=doingBusinessAs]").prev('.styled-label').append('&nbsp;<span class="styled-label-required">*</span>');
        $j("[id$=fleetSize]").val('1').attr('disabled', 'true');
        
        $j("[id$=physicalAddress]").attr('placeholder', 'Enter Your Home Address');
        $j("[id$=pgAddress]").attr('placeholder', 'Enter Your Home Address');
        $j("[id$=taxpayerId]").attr('placeholder', 'Enter Your Social Security Number (#########)');
        $j('.ssn').mask('000-00-0000');
        $j("[id$=legalStructure]").val('Proprietorship').attr('disabled', 'true');
        $j("[id$=exemptFromMotorFuelsTax]").val('No').attr('disabled', 'true');
        $j("[id$=averageMonthlyFuelExpenses]").attr("placeholder", "Enter your monthly fuel spending");
        $j("[id$=taxpayerId]").mask('000000000');
        
        
    }
    
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
    
    console.log(boca_language_code);
    
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
    if(value !== "" && isNA) {
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

function validateCanadianPostalCode(value) {
    if(value !== "" && isNA) {
        
        var characterReg = /^[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d$/i;
        if(!characterReg.test(value)) {
            return false;
        }
    }
    return true;
}

function validatePostalCode(value) {
    if(value !== "" && isNA) {
        var characterReg = /(^\d{5}$)|(^\d{5}-\d{4}$)/;
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

function validateDunsNumber(value) {
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

function validate(currentStep) {
    
    var hasErrors = false;
    
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
           
    $j('[id$=creditForm]').find('.email').each(function() {
    	if($j(this).val() != null && !validateEmail($j(this).val())) {
           	$j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Email + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
             hasErrors = true;
         }
   	});
    
    $j('[id$=creditForm]').find('.phone').each(function() {
    	if($j(this).val() != null && !validatePhone($j(this).val())) {
           	$j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Phone + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
             hasErrors = true;
         }
   	});
    
    $j('[id$=creditForm]').find('.taxpayerId').each(function() {
    	if($j("[id$=taxpayerId]").val() != null && !validateTaxpayerId($j("[id$=taxpayerId]").val())) {
           	$j("[id$=taxpayerId]").addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Tax_ID + '</div>');
            $j("[id$=taxpayerId]").on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
             hasErrors = true;
         }
   	});
    
    $j('[id$=creditForm]').find('.postal').each(function() {
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
    
    $j('[id$=creditForm]').find('.ssn').each(function() {
    	if($j(this).val() != null && !validateSSN($j(this).val())) {
           	$j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_SSN + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
             hasErrors = true;
         }
   	});

    console.log($j('[id$=checkingAccountNumber]').length);

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
    
    $j('[id$=creditForm]').find('.date').each(function() {
    	if($j(this).val() != null && !validateDateOfBirth($j(this).val())) {
           	$j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Date + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
             hasErrors = true;
         }
   	});
    
    $j('[id$=creditForm]').find('.address').each(function() {
    	if($j(this).val() != null && !validatePOBox($j(this).val())) {
           	$j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_PO_Box_Warning + '</div>');
            $j(this).on('click', function() { $j(this).removeClass("erroredInput"); $j(this).next('.fieldErrorMessage').remove(); levelSetErroredRows(); });
             hasErrors = true;
         }
   	});

   	if(!isNA) {
   	    if($j("[id$=phone]") != null && $j("[id$=phone]").val() != null) {
            var myPhone = $j("[id$=phone]").val().replace(/[\+\s\-()]/g,'');
            $j("[id$=phone]").val(myPhone);
   	    }
        if($j("[id$=bankPhone]") != null && $j("[id$=bankPhone]").val() != null) {
            var bankPhone = $j("[id$=bankPhone]").val().replace(/[\+\s\-()]/g,'');
            $j("[id$=bankPhone]").val(bankPhone); 
        }
   	}

    if(hasErrors == false) { 
        $j('[id$=creditForm]').find('.step-button').addClass('disabled-button');
        $j('[id$=creditForm]').find('.loader-gif').css('display', 'block');

        submitApplication();
    }
    else { 
        $j('[id$=errors]').css('display', 'block');   
        
        levelSetErroredRows();
        
        document.querySelector("#errors").scrollIntoView();   
        
        window.page_name = "App-Page1-Errors";
        
        if(typeof dataLayer !== 'undefined') {
            dataLayer.push({'event': 'sfdcapp_page_rerendered'});
        }
    }
}
