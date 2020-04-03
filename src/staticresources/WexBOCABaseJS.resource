$j = jQuery.noConflict(); 

$j(document).ready(function() {
    
    pageLoadFunctions();
    
});

function pageLoadFunctions() {
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
    
    	//$j("[id$=legalStructure] option[value='Limited Liability Company']").remove();
        //$j("[id$=legalStructure] option[value='Corporation/Association']").remove();
        
        $j(".postal").each(function() {
        	$j(this).addClass('postalCanada').removeClass('postal');
        });
    }
    else {
        //$j("[id$=legalStructure] option[value='Government']").remove();
        //$j("[id$=legalStructure] option[value='Religious']").remove();
        //$j("[id$=legalStructure] option[value='Other']").remove();
        var stuff = "stuff";
    }
    
	$j('.phone').mask('999-999-9999');
	$j('.ssn').mask('000-00-0000');
	$j('.date').mask('00/00/0000');
	$j('.postal').mask('00000-0000');
    $j('.postalCanada').mask('A0A-0A0');
	$j('.cpf').mask('999.999.999-99', {reverse: true});
	$j('.money').mask('000,000,000', {reverse: true});
    $j('.prefilledMoney').mask('000,000,000,000', {reverse: true});
    //$j('.prefilledMoney').mask('000,000,000,000.00', {reverse: true});
    $j('.dunsNumber').mask('000000000');
    
    // Fixing a load of picklist options
    $j("[id$=yearsInBusiness] option").eq('').text($Label.BOCA_Picklist_Choose_One);
    $j("[id$=state] option:contains('--None--')").text($Label.BOCA_Picklist_Choose_One);
    $j("[id$=pgState] option:contains('--None--')").text($Label.BOCA_Picklist_Choose_One);
    $j("[id$=billingState] option:contains('--None--')").text($Label.BOCA_Picklist_Choose_One);
    $j("[id$=exemptFromMotorFuelsTax] option").eq('').text($Label.BOCA_Picklist_Choose_One);
    $j("[id$=legalStructure] option").eq('').text($Label.BOCA_Picklist_Choose_One);
    $j("[id$=fiscalYearStarts] option[value='']").remove();
    $j("[id$=communicationPreference] option[value='']").remove();
    $j("[id$=cardUsageType] option[value='']").remove(); 
    
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

    $j(document).on( 'focus', ':input', function(){
        $j(this).attr('autocomplete', 'nope');
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

function validateTaxpayerId(value) {
    if(value !== "") {

        var characterReg = /(^\d{9}$)/;
        if(boca_language_code === "en_ca" || boca_language_code === "fr_ca") {
            characterReg = /^[a-z0-9]+$/i;
        }
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
    
    var errorCount = 0;
    var errorMessages = [];
    
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
    
    if(currentStep === 1) {
    	
        $j('[id$=creditForm]').find('.required').each(function() {
    		if($j(this).val() === "") {
                $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Required + '</div>'); errorCount++;
			}
		});
        
        if(!validatePhone($j('[id$=phone]').val())) {
        	  $j('[id$=phone]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Phone + '</div>'); errorCount++;    
        }
        
        if(!validateEmail($j('[id$=email]').val())) {
        	$j('[id$=email]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Email + '</div>'); errorCount++;     
        }
        
        if($j('[id$=fleetSize]').val() != "" && !validateFleetSize($j('[id$=fleetSize]').val())) {
           $j('[id$=fleetSize]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Number + '</div>'); errorCount++; 
        }
        
		if(errorCount == 0) { 
            $j('[id$=creditForm]').find('.step-button').addClass('disabled-button');
            $j('[id$=creditForm]').find('.loader-gif').css('display', 'block');
            window.page_name = "App-Page2";
            if(typeof dataLayer !== 'undefined') {
            	dataLayer.push({'event': 'sfdcapp_page_rerendered'});
            }
			createLead();   
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
    else if(currentStep === 2) {
    	
        $j('[id$=creditForm]').find('.required').each(function() {
    		if($j(this).val() === "" || $j(this).val() === "#") {
                $j(this).addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Required + '</div>'); errorCount++;
			}
		});
        
        if(!validatePOBox($j('[id$=physicalAddress]').val())) {
            $j('[id$=physicalAddress]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_PO_Box_Warning + '</div>'); errorCount++;
        }

        if(!validatePOBox($j('[id$=physicalAddressLine2]').val())) {
            $j('[id$=physicalAddressLine2]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_PO_Box_Warning + '</div>'); errorCount++;
        }
        
        if($j('[id$=averageMonthlyFuelExpenses]').val() !== "" && !(parseFloat($j('[id$=averageMonthlyFuelExpenses]').val().replace(/,/g,'')) > 0)) {
            $j('[id$=averageMonthlyFuelExpenses]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Amount + '</div>'); errorCount++;
        }

        if($j('[id$=estimatedFuelVolume]').val() != null && $j('[id$=estimatedFuelVolume]').val() !== "" && !(parseFloat($j('[id$=estimatedFuelVolume]').val().replace(/,/g,'')) > 0)) {
            $j('[id$=estimatedFuelVolume]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Amount + '</div>'); errorCount++;
        }

        if($j('[id$=taxpayerId]').val() !== "" && !validateTaxpayerId($j('[id$=taxpayerId]').val())) {
            $j('[id$=taxpayerId]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Tax_ID + '</div>'); errorCount++;
		}
        
        if($j('[id$=dunsNumber]').val() != null && $j('[id$=dunsNumber]').val() !== "") {
        	if(!validateDunsNumber($j('[id$=dunsNumber]').val())) {
            	$j('[id$=dunsNumber]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_DUNS + '</div>'); errorCount++;
            }
		}
        
        if(boca_language_code === "en_ca" || boca_language_code === "fr_ca") {
            if($j('[id$=postalCode]').val() != null && $j('[id$=postalCode]').val() !== "" && !validateCanadianPostalCode($j('[id$=postalCode]').val())) {
            	$j('[id$=postalCode]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Postal_Code + '</div>'); errorCount++;
        	}
        
        	// Validate billing information section
			if($j('[id$=billingPostalCode]').val() != null && $j('[id$=billingPostalCode]').val() !== "" && !validateCanadianPostalCode($j('[id$=billingPostalCode]').val())) {
            	$j('[id$=billingPostalCode]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Postal_Code + '</div>'); errorCount++;
        	}   
        }
        else {
            if($j('[id$=postalCode]').val() != null && $j('[id$=postalCode]').val() !== "" && !validatePostalCode($j('[id$=postalCode]').val())) {
	            $j('[id$=postalCode]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Postal_Code + '</div>'); errorCount++;
        	}
        
        	// Validate billing information section
			if($j('[id$=billingPostalCode]').val() != null && $j('[id$=billingPostalCode]').val() !== "" && !validatePostalCode($j('[id$=billingPostalCode]').val())) {
            	$j('[id$=billingPostalCode]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Postal_Code + '</div>'); errorCount++;
        	}   
        }
        
        //if($j('[id$=billingAddress1]').val() != null && !validatePOBox($j('[id$=billingAddress1]').val())) {
          //  $j('[id$=billingAddress1]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_PO_Box_Warning + '</div>'); errorCount++;
        //}
        
        if($j('[id$=billingPhone]').val() != null && !validatePhone($j('[id$=billingPhone]').val())) {
        	$j('[id$=billingPhone]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Phone + '</div>'); errorCount++;    
        }
        
        if($j('[id$=billingEmail]').val() != null && !validateEmail($j('[id$=billingEmail]').val())) {
        	$j('[id$=billingEmail]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Email + '</div>'); errorCount++;     
        }

        if($j('[id$=checkingAccountNumber]').length > 0 && $j('[id$=checkingAccountNumber]').val() !== "" && ($j('[id$=checkingAccountNumber]').val().length < 5 || $j('[id$=checkingAccountNumber]').val().length > 14)) {
            $j('[id$=checkingAccountNumber]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_invalid_checking_account + '</div>');
            errorCount++;
        }

        if($j('[id$=verifyCheckingAccountNumber]').length > 0 && $j('[id$=verifyCheckingAccountNumber]').val() !== "" && $j('[id$=checkingAccountNumber]').val() !== $j('[id$=verifyCheckingAccountNumber]').val()) {
            $j('[id$=verifyCheckingAccountNumber]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_unmatched_checking_account + '</div>');
            errorCount++;
        }

        if($j('[id$=verifyAbaRoutingNumber]').length > 0 && $j('[id$=verifyAbaRoutingNumber]').val() !== "" && $j('[id$=abaRoutingNumber]').val() !== $j('[id$=verifyAbaRoutingNumber]').val()) {
            $j('[id$=verifyAbaRoutingNumber]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_unmatched_routing_number + '</div>');
            errorCount++;
        }

        if($j('[id$=abaRoutingNumber]').length > 0 && $j('[id$=abaRoutingNumber]').val() !== "" && $j('[id$=abaRoutingNumber]').val().length < 9) {
            $j('[id$=abaRoutingNumber]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_invalid_routing_number + '</div>');
            errorCount++;
        }
        
        if($j('[id$=isPG]').val() === "true") {
            
            if(!validatePOBox($j('[id$=pgAddress]').val())) {
            	$j('[id$=pgAddress]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_PO_Box_Warning + '</div>'); errorCount++;
        	}
        
        	if($j('[id$=pgSSN]').val() !== "" && !validateSSN($j('[id$=pgSSN]').val())) {
            	$j('[id$=pgSSN]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_SSN + '</div>'); errorCount++;    
            }
        
	        if($j('[id$=pgPostalCode]').val() !== "" && !validatePostalCode($j('[id$=pgPostalCode]').val())) {
    	        $j('[id$=pgPostalCode]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Postal_Code + '</div>'); errorCount++;
        	}
        
        	if($j('[id$=pgPhone]').val() !== "" && !validatePhone($j('[id$=pgPhone]').val())) {
            	$j('[id$=pgPhone]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Phone + '</div>'); errorCount++;
			}
        
            if($j('[id$=pgDateOfBirth]').val() !== "" && !validateDateOfBirth($j('[id$=pgDateOfBirth]').val())) {
	            $j('[id$=pgDateOfBirth]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Date + '</div>'); errorCount++;    
    	    }

			if($j('[id$=pgIncome]').val() !== "" && !(parseFloat($j('[id$=pgIncome]').val().replace(/,/g,'')) > 0)) {
            	$j('[id$=pgIncome]').addClass('erroredInput').after('<div class="fieldErrorMessage">' + $Label.BOCA_Invalid_Amount + '</div>'); errorCount++;
        	}

        }
        
        console.log(errorCount);
        
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
            
            window.page_name = "App-Page2-Errors";
            
            if(typeof dataLayer !== 'undefined') {
            	dataLayer.push({'event': 'sfdcapp_page_rerendered'});
            }
        	document.querySelector("#errors").scrollIntoView();  
        }
    }
    
    console.log(page_name);
    
}