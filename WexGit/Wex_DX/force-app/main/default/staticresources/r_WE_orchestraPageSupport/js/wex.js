var surl = '';
var putil = 'WE_PortalUtilityAjax';
var programname = '';
var defaulttc = '';
var defaultpc = '';
var defaultcpid = '';
var bLead = false;
var sess = '';
var tm_org_id = 'bkwau9ws';
var tm_sess_id = '';
var ip = '';
var hexfirst = '';
var hexsecond = '';
var bordercolor = '';
var footercolor = '';
var leftmenumargin = '';
var hexbtnfirst = '';
var hexbtnsecond = '';

var loadingGif = pathToResources() +'imgs/ajax-loader.gif';
imgLoader = new Image();
imgLoader.src = loadingGif;

String.prototype.contains = function(it) { return this.indexOf(it) != -1; };

function pathToResources(fileName) {
	// note: by default, it returns the path to the resource that holds ocms-extensions.js
	// returns: undefined if can't find script; null or script full path if unexpected format
	var fileName = fileName || 'ocms-extensions.pack.js',
	    // note: using jQuery Ends With Selector $=
	    $thisScript = $('script[src$="' + fileName + '"]'),
		rPath = '';

    if ($thisScript.length) {
        rPath = $thisScript.attr('src');
		var re = /(\/.+)?\/resource\/[0-9]+\/[^\/]+\//;
		var arrRPath = rPath.match(re);
		if (arrRPath)
		{
			rPath = arrRPath[0];
		} else {
			rPath = '/';
		}
    }
    return rPath;
}	// pathToResources

function setupBackground(){
	hexfirst = $('div#OCMSWE-head-color-from').text().trim();
	hexsecond = $('div#OCMSWE-head-color-to').text().trim();
	bordercolor = $('div#OCMSWE-topline-color').text().trim();
	footercolor = $('div#OCMSWE-foot-color').text().trim();
	leftmenumargin = $('div#OCMSWE-left-margin').text().trim();
	hexbtnfirst = $('div#OCMSWE-submit-color-from').text().trim();
	hexbtnsecond = $('div#OCMSWE-submit-color-to').text().trim();

		if (hexfirst.length && hexsecond.length) {
			$('.document-1-title,.uiBucketHeading,.terms h2,.branded h2').css("background-image", "linear-gradient(bottom, #" + hexfirst + " 30%, #" + hexsecond + " 69%)");
			$('.document-1-title,.uiBucketHeading,.terms h2,.branded h2').css("background-image", "-o-linear-gradient(bottom, #" + hexfirst + " 30%, #" + hexsecond + " 69%)");
			$('.document-1-title,.uiBucketHeading,.terms h2,.branded h2').css("background-image", "-moz-linear-gradient(bottom, #" + hexfirst + " 30%, #" + hexsecond + " 69%)");
			$('.document-1-title,.uiBucketHeading,.terms h2,.branded h2').css("background-image", "-webkit-linear-gradient(bottom, #" + hexfirst + " 30%, #" + hexsecond + " 69%)");
			$('.document-1-title,.uiBucketHeading,.terms h2,.branded h2').css("background-image", "-ms-linear-gradient(bottom, #" + hexfirst + " 30%, #" + hexsecond + " 69%)");
			$('.document-1-title,.uiBucketHeading,.terms h2,.branded h2').css("filter", "progid:DXImageTransform.Microsoft.gradient( startColorstr='#" + hexfirst + "', endColorstr='#" + hexsecond + "',GradientType=0)");
		}
		if(bordercolor.length) {
			$('.top').css("border-bottom-color", "#"+bordercolor);
		}
		if(footercolor.length) {
			$('.footer').css("background-color", "#"+footercolor);
		}
		if(leftmenumargin.length) {
			$('.left .card p').css("marginLeft", leftmenumargin+"px");
		}
		if(hexbtnfirst.length && hexbtnsecond.length) {
			$('.main .formButtons .submitApp').css("background-image", "linear-gradient(bottom, #"+hexbtnfirst+" 30%, #"+hexbtnsecond+" 69%)");
			$('.main .formButtons .submitApp').css("background-image", "-o-linear-gradient(bottom, #"+hexbtnfirst+" 30%, #"+hexbtnsecond+" 69%)");
			$('.main .formButtons .submitApp').css("background-image", "-moz-linear-gradient(bottom, #"+hexbtnfirst+" 30%, #"+hexbtnsecond+" 69%)");
			$('.main .formButtons .submitApp').css("background-image", "-webkit-linear-gradient(bottom, #"+hexbtnfirst+" 30%, #"+hexbtnsecond+" 69%)");
			$('.main .formButtons .submitApp').css("background-image", "-ms-linear-gradient(bottom, #"+hexbtnfirst+" 30%, #"+hexbtnsecond+" 69%)");
			$('.main .formButtons .submitApp').css("filter", "progid:DXImageTransform.Microsoft.gradient( startColorstr='#" + hexbtnfirst + "', endColorstr='#" + hexbtnsecond + "',GradientType=0)");
		}
}

function setupLogin() {

	$signInContainer = $('div.portallogin');
	setupProgress('div.portallogin div.uiBucketPanel');
	OCMS.signInTransmogrifier({
		selector: $signInContainer,
		newTemplate: '<span style="display: none;">{forgot}</span><table><tr><td class="column_0"><span class="text">{userLabel}</span></td><td class="column_1">{user}</td><td class="column_2"><span class="text">{passwordLabel}</span></td><td class="column_3">{password}</td></tr><tr><td class="column_0"></td><td class="column_1"></td><td class="column_2"></td><td class="column_3">{signIn}</td></tr></table><div class="signInError" data-errorcode="{errorMessageClass}">{errorMessage}</div>',
		addClasses: true,
		text: {
			userLabel: 'Email Address:',
			passwordLabel : 'Password:',
			signIn: 'Login'
			}
	});

	$('input.ocmsLoginButton').click(function() {
		$('input.ocmsUsername').val($('input.ocmsUsername').val() + '.' + programname);
		return true;
	});
	$('form.ocmsPortalLoginComponent').submit(function() {
		showProgress('div.portallogin div.uiBucketPanel');
		return true;
	});
	$('input.ocmsUsername').blur(handleEmailValidation);
}

function setupApplicationForm() {
	$('form.ocms-ajax-form').attr('action','');
	$('form.ocms-ajax-form table.ui-superform').hide();
 	getProgram();
	var objectApiName = '';
    var jsonObj = jQuery.parseJSON($('.JSONOptionsString').text());
    if(jsonObj != null && jsonObj.ObjectAPIName != null && jsonObj.ObjectAPIName != '') {
		objectApiName = jsonObj.ObjectAPIName;
		if(jsonObj.Fields != null && jsonObj.Fields.length > 0) {
			for(i = 0;i<jsonObj.Fields.length;i++) {
				var fieldHint = '';
				var fieldHelp = '';
				var fieldError = '';
				var fieldApiName = jsonObj.Fields[i].FieldAPIName;
				var inputFieldClass = '.'+objectApiName+'_'+fieldApiName;
				if(jsonObj.Fields[i].Hint != null) {
					fieldHint = jsonObj.Fields[i].Hint;
					$(inputFieldClass).attr('placeholder',fieldHint);
				}
				if(jsonObj.Fields[i].Help != null) {
					fieldHelp = jsonObj.Fields[i].Help;
					$(inputFieldClass).parent().append('<span class="pic helpicon'+i+'"></span>');
					//Script for tooltip
					$('.helpicon'+i).qtip({
						content: fieldHelp,
                        position: {
                        	my: 'left center',
                            at: 'right center',
                            viewport: $(window),
                            adjust: {
                            	method: 'flip'
                            }
                        },
                        style: {
                            tip: true,
                            classes: 'ui-tooltip-dark'
                        },
                    });
                }

                if (jsonObj.Fields[i].Error != null)
				{
					fieldError = jsonObj.Fields[i].Error;
				}

				if (jsonObj.Fields[i].Validate != null)
				{
					if (jsonObj.Fields[i].Validate == 'Email')
					{
						$(inputFieldClass).blur(handleEmailValidation);
					}
				}

				if (jsonObj.Fields[i].Format != null)
				{
					$(inputFieldClass).mask(jsonObj.Fields[i].Format);
				}

				if (jsonObj.Fields[i].Uppercase != null && jsonObj.Fields[i].Uppercase == 'true')
				{
					$(inputFieldClass).addClass('uppercase');
				}
            }
        }
        $.each(OCMS.getURLParameters(), function(index, value){
        	$('.' + objectApiName + '_' + index).val(value);
        });
    }

	heightArray = new Array();
	$('.accordion .accContent').each(function(i) {
		theHeight = $(this).height();
		heightArray[i] = theHeight;
	});
	$('.accheader').next().hide();
	$('.accordion .accheader').click(function() {
		$(this).next(".accContent").addClass('accactive').css({height: heightArray[$(".accordion  .accheader").index(this)]});
		if($(this).attr('class') != 'accheader hactive'){
			$('.accactive').slideUp();
			$('.accheader').removeClass('hactive');
			$(this).addClass('hactive');
			$(this).next().slideDown().addClass('accactive');
			return false;}
	});

    //Checkbox merge with label
    if($('.forCheckbox') != null && $('.forCheckbox').length> 0) {
        if($('.forCheckbox').length > 1){
            var checkboxes = $('.forCheckbox');
            for(var i=0; i<checkboxes.length;i++) {
                var checkboxNewClass = 'checkbox'+i;
                checkboxes[i].className = checkboxes[i].className+' '+checkboxNewClass;
                $('.'+checkboxNewClass).unwrap().attr('style','float:left;margin:0;');
                var forCheckboxClass = $('.'+checkboxNewClass).prev().children().unwrap().attr('style','margin-left:25px;float:left;width:15px !important;').attr('class');
                $('.'+checkboxNewClass+', .'+forCheckboxClass).wrapAll('<td colspan="2" style="width:210px !important;"></td>');
            }
        }
        else {
            $('.forCheckbox').unwrap().attr('style','float:left;margin:0;');
            var forCheckboxClass = $('.forCheckbox').prev().children().unwrap().attr('style','margin-left:25px;float:left;width:15px !important;').attr('class');
            $('.forCheckbox, .'+forCheckboxClass).wrapAll('<td colspan="2" style="width:210px !important;"></td>');
        }

        $('.'+objectApiName+'_Same_as_Business_Address__c').live('mousedown', function() {
        	if (!$(this).is(':checked')) {
            	$('.'+objectApiName+'_Billing_Street_Address__c').val($('.'+objectApiName+'_Business_Street_Address__c').val());
                $('.'+objectApiName+'_Billing_Address_Line_2__c').val($('.'+objectApiName+'_Address_Line_2__c').val());
                $('.'+objectApiName+'_Billing_City__c').val($('.'+objectApiName+'_City__c').val());
                $('.'+objectApiName+'_Billing_State__c').val($('.'+objectApiName+'_State__c').val());
                $('.'+objectApiName+'_Billing_State__c').siblings('select').val($('.'+objectApiName+'_State__c').val());
                $('.'+objectApiName+'_Billing_Zip_Code__c').val($('.'+objectApiName+'_Zip_code__c').val());
        	} else {
        		$('.'+objectApiName+'_Billing_Street_Address__c').val('');
                $('.'+objectApiName+'_Billing_Address_Line_2__c').val('');
                $('.'+objectApiName+'_Billing_City__c').val('');
                $('.'+objectApiName+'_Billing_State__c').val('');
                $('.'+objectApiName+'_Billing_State__c').siblings('select').val('--Select--');
                $('.'+objectApiName+'_Billing_Zip_Code__c').val('');
        	}
   	    });
    }

	//Script for 100% bottom text in td
	$('.txtform').parent('td').attr('style','width:100% !important;padding: 10px;');

	//Script for smaller inputs, if block has a help icon
	$('.pic').prev().attr('style','width:120px !important;');

	//Add class for headers
	$('.uiBucketHeading').parent().parent().addClass('headForm');
	$('.free').parent().css('height','0px');
	$('.free').parent().parent().addClass('freeTr');
	$('.freeTr').prev().css('background-image','none');

	setupBackground();
	$('#regUserSaveForLaterText').empty().append($('.saveForLaterInstructions').html());
	setClassOnPicklists();

	// setup event handlers
	$('a.saveForLaterLink').click(saveForLater);
	$('button#regReturn').click(returnToApp);
	$('button#regBtn').click(registerUser);

	$('input#regUsername').blur(handleEmailValidation);
	if ($(document).data('cms').isGuest == true) {
		$('form.ocms-ajax-form input').blur(function(){
			saveData(true, 'autosave', true);
		});
		$(window).unload(function() {
			saveData(true, 'abandoned', false);
		});
	}
	setupProgress('div.formButtons');
	setupProgress('table#regTab');
	getSavedData();
	toggleLogout();
	getIP();
	$('input.' + objectApiName + '_IPAddress__c').val(ip);

/*
	var applyBtn = '<button class="promoApply">Apply Code</button>';
	$('input.' + objectApiName + '_Promotional_Code__c').closest('td').next('td').append(applyBtn);
	$('button.promoApply').click(function(){
		validatePromoCode('input.' + objectApiName + '_Promotional_Code__c', $('input.' + objectApiName + '_Promotional_Code__c').val());
	});
*/
	//  Setup a handler to validate the promo code whenever we leave the field
	$('input.' + objectApiName + '_Promotional_Code__c').live('blur', function(){
		validatePromoCode(this, $(this).val());
	});

	//  hide the first 2 rows by adding a class and using CSS selector to hide
	$('form.ocms-ajax-form table.ui-superform td.row_0.column_0').closest('tr').addClass('ocmsHiddenField');
	$('form.ocms-ajax-form table.ui-superform td.row_1.column_0').closest('tr').addClass('ocmsHiddenField');
	$('form.ocms-ajax-form table.ui-superform').show();

	//  In case we loaded in the promo code, validate it
	validatePromoCode('input.' + objectApiName + '_Promotional_Code__c', $('input.' + objectApiName + '_Promotional_Code__c').val());
}

function handleEmailValidation(event)
{
	if ($(this).parent().hasClass('invalid'))
	{
		$(this).parent().qtip("destroy");
		$(this).unwrap();
		$(this).attr('style','width: 200px;');
	}
	if ($(this).val() != '') {
		if (!OCMS.isValidEmailAddress($(this))) {
			event.stopPropagation();
			$(this).wrap('<div class="invalid"/>').fadeIn('slow');
			$('.invalid').children().attr('style','width:125px !important;');
			$(this).parent().qtip({
				content: 'Field must be in format of username@domain.com',
				position: {
					my: 'left center',
					at: 'right center',
					viewport: $(window),
					adjust: {
						method: 'flip'
					}
				},
				style: {
					tip: true,
					classes: 'ui-tooltip-dark'
				},
				show : {
					ready: true
				}
			});
			$(this).focus();
			return false;
		}
	}
}

// class is not set on picklists, set it here
function setClassOnPicklists()
{
	var $sel = $('div.input-PICKLIST');
	$.each($sel, function() {
		$('input[type=hidden]', this).addClass($('div.object-name', this).text() + '_' + $('div.object-field', this).text());
	});
}

function setupProgress(elem)
{
	prep = elem || 'body';
	var html = '<div class="ajaxProgress" style="display:none;"><img id="progressImage" src="' + loadingGif + '" /></div>';
	$(html).prependTo(prep);
}

jQuery.fn.center = function () {
    this.css("position", "absolute");
//    this.css("top", ($(window).height() - this.height())/ 2 + $(window).scrollTop() + "px");
//    this.css("left", ($(window).width() - this.width()) / 2 + $(window).scrollLeft() + "px");
    this.css("top", ($(this).parent().height() - this.height())/ 2 + $(this).parent().scrollTop() + "px");
    this.css("left", ($(this).parent().width() - this.width()) / 2 + $(this).parent().scrollLeft() + "px");
    return this;
}

function showProgress(container) {
	c = container || 'body';
	$(c + ' div.ajaxProgress').center();
	$(c + ' div.ajaxProgress').show();
}

function hideProgress(container) {
	c = container || 'body';
	$(c + ' div.ajaxProgress').hide();
}

function styleElements(elem, btn){
	if (hexfirst && hexsecond) {
		$(elem).css("background-image", "linear-gradient(bottom, #" + hexfirst + " 30%, #" + hexsecond + " 69%)");
		$(elem).css("background-image", "-o-linear-gradient(bottom, #" + hexfirst + " 30%, #" + hexsecond + " 69%)");
		$(elem).css("background-image", "-moz-linear-gradient(bottom, #" + hexfirst + " 30%, #" + hexsecond + " 69%)");
		$(elem).css("background-image", "-webkit-linear-gradient(bottom, #" + hexfirst + " 30%, #" + hexsecond + " 69%)");
		$(elem).css("background-image", "-ms-linear-gradient(bottom, #" + hexfirst + " 30%, #" + hexsecond + " 69%)");
		$(elem).css("filter", "progid:DXImageTransform.Microsoft.gradient( startColorstr='#" + hexfirst + "', endColorstr='#" + hexsecond + "',GradientType=0)");
		if (hexbtnfirst && hexbtnsecond) {
			$(btn).css("background-image", "linear-gradient(bottom, #" + hexbtnfirst + " 30%, #" + hexbtnsecond + " 69%)");
			$(btn).css("background-image", "-o-linear-gradient(bottom, #" + hexbtnfirst + " 30%, #" + hexbtnsecond + " 69%)");
			$(btn).css("background-image", "-moz-linear-gradient(bottom, #" + hexbtnfirst + " 30%, #" + hexbtnsecond + " 69%)");
			$(btn).css("background-image", "-webkit-linear-gradient(bottom, #" + hexbtnfirst + " 30%, #" + hexbtnsecond + " 69%)");
			$(btn).css("background-image", "-ms-linear-gradient(bottom, #" + hexbtnfirst + " 30%, #" + hexbtnsecond + " 69%)");
			$(btn).css("filter", "progid:DXImageTransform.Microsoft.gradient( startColorstr='#" + hexbtnfirst + "', endColorstr='#" + hexbtnsecond + "',GradientType=0)");
		}
	}
}

function getParamValue(name) {
	name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]").toLowerCase();
	var regexS = "[\\?&]"+name+"=([^&#]*)";
	var regex = new RegExp( regexS );
	var results = regex.exec( window.location.href.toLowerCase() );
	if( results == null )
		return "";
	else
		return decodeURIComponent(decodeURIComponent(results[1].replace(/\+/g, " "))).replace(/\+/g, " ");
}

function validateSuperForm() {
	showProgress('div.formButtons');
	var errorCounter = 0;
	var validationArr = [];
	var jsonObjt = jQuery.parseJSON($('.JSONOptionsString').text());
	if(jsonObjt != null && jsonObjt.ObjectAPIName != null && jsonObjt.ObjectAPIName != '') {
		var objectApiName = jsonObjt.ObjectAPIName;
		// setup threatmetrix session id; this is on form submit; not save for later
		$('input.' + objectApiName + '_TM_Session_ID__c').val(tm_sess_id);

		if(jsonObjt.Fields != null && jsonObjt.Fields.length > 0) {
			if($('.invalid').size() > 0) {
				$('.invalid').children().unwrap();
			}
			if($('.ui-invalid').size() > 0) {
				$('.ui-invalid').remove();
			}
			for(i = 0;i<jsonObjt.Fields.length;i++) {
				var fieldError = '';
				var fieldApiName = jsonObjt.Fields[i].FieldAPIName;
				var inputFieldClass = '.'+objectApiName+'_'+fieldApiName;
				if(jsonObjt.Fields[i].Error != null && jsonObjt.Fields[i].Error != '') {
					fieldError = jsonObjt.Fields[i].Error;

					var isCheckbox = $(inputFieldClass).attr('type') === 'checkbox';
					var cb_required = isCheckbox === true ? $(inputFieldClass).hasClass('required') : false;
					var isRequiredCBChecked = cb_required === true ? $(inputFieldClass).attr('checked') : false;

					if (isCheckbox && cb_required) {
						errorCondition = isRequiredCBChecked === true ? false : true;
					} else {
						errorCondition = $.trim($(inputFieldClass).val()) === '';
					}

					if (errorCondition) {
					// if($.trim($(inputFieldClass).val()) == '') {
						validationArr.push({
							fieldClass: inputFieldClass,
							fieldError: jsonObjt.Fields[i].Error});
							errorCounter++;
							if ($(inputFieldClass).parent('.input-PICKLIST').length) {
								var selectWidth = $(inputFieldClass)
													.siblings('select').width();
								$(inputFieldClass)
									.parent('.input-PICKLIST')
									.wrap('<div class="invalid" style="width:' + (selectWidth + 15)+ 'px"/>')
									.fadeIn('slow');

							} else {
								$(inputFieldClass).wrap('<div class="invalid"/>').fadeIn('slow');
							}
							$('.invalid').next('.pic').attr('style','margin-top: 5px !important;');
							$('.invalid').children().attr('style','width:125px !important;');
							$('.pic').prev().attr('style','width:120px !important;');
							$('.pic').prev().children().attr('style','width: 100px !important;');
							$(inputFieldClass).parent().qtip({
								content: fieldError,
								position: {
									my: 'left center',
                                    at: 'right center',
                                    viewport: $(window),
                                    adjust: {
                                        method: 'flip'
                                    }
                                },
                                style: {
                                    tip: true,
                                    classes: 'ui-tooltip-dark'
                                }
							});
						}
					}
				}
				if(errorCounter == 0)
				{
					//  turn off the unload handler
					$(window).unbind('unload');
					saveData(true, 'submitted', false);
					$('.ocms-ajax-form').submit();
					hideProgress('div.formButtons');
				}
				if (errorCounter > 0) {
					$('.forms').prepend('<p class="ui-invalid"><strong>Please note:</strong> There are ' + errorCounter + ' errors in this page.</p>');
					$("html, body").animate({ scrollTop: 0 }, "slow");
				}
				else {
					$('.ui-invalid').remove();
					$('html,body').scrollTop('.ui-invalid');
				}
			}
		}
	//for(i = 0;i<validationArr.length;i++)
	//alert(validationArr[i].fieldClass+'   '+validationArr[i].fieldError);
	$('.ocms-ajax-form').prev('ul').attr('class','ui-invalid');
	hideProgress('div.formButtons');
}

function setDefaultPromoCode()
{
	$('input.WeFormObject__c_Campaign_Program_ID__c').val(defaultcpid);
	$('input.WeFormObject__c_Promotional_Code__c').val(defaultpc);
	var sHTML = '<div class="uiBucketPanel"><div class="controlsScrollVertical tcScrollable">' + defaulttc + '</div></div>';
	$('div.termsContent').empty().append(sHTML);
	addDefaultContentTC();
}

function validatePromoCode(field, code)
{
	var row = $(field).closest('tr').selector;
	setupProgress(row);
	if ($(field).parent().hasClass('invalid')) $(field).unwrap();
	if (code == null || code == '')
	{
		setDefaultPromoCode();
		return false;
	}
	else
	{
		showProgress(row);
		var params = {'action': 'validateCoupon', 'coupon': code, 'program': programname};
		$.orchestracmsRestProxy.doAjaxJsonCall(putil, params, function(json, textStatus, xhr) {
			if (json.status == "success")
			{
				$('input.WeFormObject__c_Campaign_Program_ID__c').val(json.tc.id);
				var sHTML = '<div class="uiBucketPanel"><div class="controlsScrollVertical tcScrollable">' + json.tc.terms + '</div></div>';
				$('div.termsContent').empty().append(sHTML);
				addDefaultContentTC();
				hideProgress(row);
				return true;
			}
			else
			{
				hideProgress(row);
/*
				$(field).wrap('<div class="invalid"/>').fadeIn('slow');
				$(field).parent().qtip({
					content: 'Invalid promotional code.  Please re-enter.',
					position: {
						my: 'left center',
						at: 'right center',
						viewport: $(window),
						adjust: {
							method: 'flip'
						}
					},
					style: {
						tip: true,
						classes: 'ui-tooltip-dark'
					},
					show : {
						ready: true
					}
				});
				$(field).focus();
*/
				setDefaultPromoCode();
				return false;
			}
		}
		,true,'c');
	}
}

function getSession()
{
	var params = {'action':'getSessionId'};
	$.orchestracmsRestProxy.doAjaxJsonCall(putil, params, function(json, textStatus, xhr){
		if (json.status == "success") {
			sess = json.id;
		}
	}
	,false,'c');
}

function toggleLogout()
{
	if ($(document).data('cms').isGuest)
	{
		$('.logout').hide();
	}
	else
	{
		$('.logout span.loginStatus').text($(document).data('cms').username + '  |  ');
		//$('.logout').show();
		$('a.logoutBtn').click(logout);
	}
}

function logout()
{
	$.ajax({url: 'secur/logout.jsp', success: function() {
		clearData();
		$('.logout').hide();
		$('input#regUsername, input#regPassword, input#regPwdConfirm').val('');
		cms = $(document).data('cms');
		cms.username = "Guest";
		cms.isGuest = true;
		$(document).data('cms', cms);
	},
	type: "POST", async: false});
}

function registerUser() {
	uname = $('div#regUser input#regUsername').val();
	pwd = $('div#regUser input#regPassword').val();
	pwdc = $('div#regUser input#regPwdConfirm').val();
	bloggedin = false;
	if (uname != undefined && uname.length >= 6)
	{
		if (pwd != undefined && pwd.length >= 6)
		{
			if (pwdc != undefined && pwd == pwdc)
			{
				$('#cboxLoadingGraphic').show();
				var uparams = {'action': 'createPortalUser', 'username': uname, 'password': pwd, 'program': programname};
				$.orchestracmsRestProxy.doAjaxJsonCall(putil, uparams, function(json, textStatus, xhr) {
					if (json.status == "success")
					{
						$.ajax({url: json.returl, success: function() {
							$("div#regUserErrors").empty().hide();
							cms = $(document).data('cms');
							cms.username = uname + '.' + programname;
							cms.isGuest = false;
							$(document).data('cms', cms);
							toggleLogout();
							saveData(false, 'saveforlater', true);
							$('#cboxLoadingGraphic').hide();
							$.fn.colorbox.close();
							return true;
						}, type: "POST", async: true});
					}
					else
					{
						$("div#regUserErrors").show().text(json.error);
						$('#cboxLoadingGraphic').hide();
						return false;
					}
				}
				,true,'c');
			}
			else
			{
				$("div#regUserErrors").show().text('Confirmation password does not match password');
				return false;
			}
		}
		else
		{
			$("div#regUserErrors").show().text('Password must be at least 6 characters in length.');
			return false;
		}
	}
	else
	{
		$("div#regUserErrors").show().text('Invalid username');
		return false;
	}
}

function returnToApp() {
	$.fn.colorbox.close();
}

function saveForLater(){
	if ($(document).data('cms').isGuest == true) {
		var opts = {
			'title': '',
			'open': true,
			'inline': true,
			'innerWidth': '660px',
			'height': '335px',
			'href': 'div#regUser',
			'opacity': 0.5,
			'close': 'CLOSE',
			'overlayClose': false,
			'onComplete': styleElements('.regUserTitle', '#regBtn')
		}
		$.fn.colorbox.settings.opacity = 0.5;
		$.fn.colorbox.settings.close = 'CLOSE';
		$.fn.colorbox(opts);
		hideProgress('table#regTab');
		return false;
	}
	else {
		showProgress('div.formButtons');
		saveData(false, 'saveforlater', false);
		hideProgress('div.formButtons');
	}
}

function clearData() {
	$('form.ocms-ajax-form input[name^="f_"]').val('');
}

function saveData(bAutoSave, status, bAsync) {
	var pcli_id = $('form.ocms-ajax-form input[name="pcli_id"]').val();
	var content_id = $('form.ocms-ajax-form input[name="content_id"]').val();
	var username = $(document).data('cms').username;
	var serData = $('form.ocms-ajax-form').serializeObject();
	serData["program"] = {"value":programname,"klass":$('OCMSWE-programname').text()};
	var sStatus = status;
	serData["status"] = {"value":sStatus,"klass":""};
	serData["sess"] = {
		"value": sess,
		"klass": ""
	};
	var formData = JSON.stringify(serData);
	var params = {'action': 'saveData', 'program': programname, 'pcli_id': pcli_id, 'content_id': content_id, 'username': username, 'data': formData, 'status' : sStatus, 'sess' : sess};
	$.orchestracmsRestProxy.doAjaxJsonCall('WE_OCMSFormAjax', params, function(json, textStatus, xhr) {
		if (json.status == "success")
		{
			if (bAutoSave != true) {

				var params = {
					'action': 'sendconfirm',
					'username': username,
					'program': programname
				};
				$.orchestracmsRestProxy.doAjaxJsonCall(putil, params, function(json, textStatus, xhr){
					if (json.status == "success") {
						logout();
						var target = $('ul li.saveconfirmtarget > a').attr('href');
						$(window).unbind('unload');  // we don't want to abandon, saving for later
						$('div.pgApplicationForm').hide();
						window.location.replace(target);
					}
				}, true, 'c');
			}
		}
		else
		{
			alert("Problem saving: " + json.error);
		}
	}
	,bAsync,'c');
}

function getSavedData() {
	var pcli_id = $('form.ocms-ajax-form input[name="pcli_id"]').val();
	var content_id = $('form.ocms-ajax-form input[name="content_id"]').val();
	var username = $(document).data('cms').username;
	var data = {'action': 'getData', 'pcli_id': pcli_id, 'content_id': content_id, 'username': username};
	$.orchestracmsRestProxy.doAjaxJsonCall('WE_OCMSFormAjax', data, function(json, textStatus, xhr) {
		if (json.status == "success")
		{
			formData = json.data;
			$.each(formData, function(key, value) {
				if (key.match("f_"))
				{
					var $i = $('form.ocms-ajax-form input#'+key);
					$i.val(value.value);
					var $p = $i.parent();
					if ($p.hasClass('input-PICKLIST'))
					{
						$('option',$p).livequery(function(){
								if ($(this).text() == value.value)
								{
									$(this).attr('selected', true);
								}
							});
					}
				}
			});
			return true;
		}
	}
	,false,'c');
	return false;
}

function getProgram() {
	var params = {'action': 'getProgram', 'program': programname};
	$.orchestracmsRestProxy.doAjaxJsonCall(putil, params, function(json, textStatus, xhr) {
		if (json.status == "success")
		{
			defaultcpid = json.tc.id;
			$('input.WeFormObject__c_Campaign_Program_ID__c').val(json.tc.id);
			defaultpc = json.tc.promo_code;
			$('input.WeFormObject__c_Promotional_Code__c').val(defaultpc);
			defaulttc = json.tc.terms;
			var sHTML = '<div class="uiBucketPanel"><div class="controlsScrollVertical tcScrollable">' + defaulttc + '</div></div>';
			$('div.termsContent').empty().append(sHTML);
			addDefaultContentTC();
		}
	}
	,false,'c');
}

function addDefaultContentTC()
{
	var dctc = $('div.defaultTerms > span > span');
	$.each(dctc, function() {
		if ($(this).html().length) {
			$('div.tcScrollable').append('<br />' + $(this).html());
		}
	});
}

function confirmAppSubmit() {
	var id = OCMS.urlParameters.Id == undefined ? OCMS.urlParameters.id : OCMS.urlParameters.Id;
	var params = {'action': 'sendappsubmitconfirm', 'id': id, 'program': programname};
	$.orchestracmsRestProxy.doAjaxJsonCall(putil, params, function(json, textStatus, xhr) {
		if (json.status == "success")
		{
		}
	}
	,false,'c');
}

function getAppStatus() {
	var id = OCMS.urlParameters.Id == undefined ? OCMS.urlParameters.id : OCMS.urlParameters.Id;
	var params = {'action': 'getAppStatus', 'id': id};
	$.orchestracmsRestProxy.doAjaxJsonCall(putil, params, function(json, textStatus, xhr) {
		if (json.status == "success")
		{
			var st = json.appstatus.Status;
			var number = json.appstatus.Number;
			var st_url = window.location.protocol + '//' +
						 window.location.hostname +
						 $('ul li.appstatustarget a').attr('href') + '?id=' + json.appstatus.Id;
			var st_aurl = '<a href="'+st_url+'">'+st_url+'</a>';
			var $t = $('div.main div.branded span.text');
			$t.each(function() {
				var s = $(this).html();
				s = s.supplant({
					oppnum: number
				});
				s = s.supplant({
					oppurl: st_aurl
				});
				s = s.supplant({
					oppstatus: st
				});
				$(this).html(s);
			});
		}
	}
	,false,'c');
}

function getSecureURL() {
	var sname = $(document).data('cms').site_name;
	var params = {'action': 'getSecure', 'sname': sname};
	$.orchestracmsRestProxy.doAjaxJsonCall(putil, params, function(json, textStatus, xhr) {
		if (json.status == "success")
		{
			surl = json.surl + 'apex/';
			putil = surl + 'WE_PortalUtilityAjax';
		}
	}
	,false,'c');
}

function getIP() {
	var params = {'action': 'getIP'};
	$.orchestracmsRestProxy.doAjaxJsonCall(putil, params, function(json, textStatus, xhr) {
		if (json.status == "success")
		{
			ip = json.ip;
		}
	}
	,false,'c');
	return ip;
}

$.fn.serializeObject = function()
{
   var o = {};
   var a = this.serializeArray();
   $.each(a, function() {
       if (o[this.name]) {
           if (!o[this.name].push) {
               o[this.name] = [o[this.name]];
           }
           o[this.name].push(this.value || '');
       } else {
           o[this.name] = {"value":this.value || '', "klass":getFirstClass(this.name)};
       }
   });
   return o;
};

function getFirstClass(fname) {
	var cl = $('form.ocms-ajax-form input[name="' + fname + '"]').attr('class');
	var icl = cl.split(' ');
	if (icl) {
		return icl[0];
	}
}

function replaceAll(txt, replace, with_this) {
	return txt.replace(new RegExp(replace, 'g'),with_this);
}

function setupThreatMetrix() {
	// Threatmetrix Cybercrime Defender Platform - Implementation Guide V3.5.pdf page 15
	//   session_id can be up to 128 bytes long and must consist of the following characters only:
	//       - Upper and lowercase English letters (a-z, A-Z)
	//       - Digits (0-9)
	//       - Underscore
	//       - Hyphen
	tm_sess_id = sess.replace(/[!.]/g, function(c) {
		var r = Math.random() * 16|0,
			v = c == '.' ? r : (r&0x3|0x8);
			return v.toString(16);
	});

	var tm = '<div style="background:url(https://images.applyfleet.com/fp/clear.png?org_id=' + tm_org_id + '&amp;session_id=' + tm_sess_id + '&amp;m=1)"> </div>';
	tm    += '<img src="https://images.applyfleet.com/fp/clear.png?org_id=' + tm_org_id + '&amp;session_id=' + tm_sess_id + '&amp;m=2" />';
	tm    += '<script src="https://images.applyfleet.com/fp/check.js?org_id=' + tm_org_id + '&amp;session_id=' + tm_sess_id + '"> </script>';
	tm    += '<object type="application/x-shockwave-flash" data="https://images.applyfleet.com/fp/fp.swf?org_id=' + tm_org_id + '&amp;session_id=' + tm_sess_id + '" width="1" height="1">';
	tm    += '<param name="movie" value="https://images.applyfleet.com/fp/fp.swf?org_id=' + tm_org_id + '&amp;session_id=' + tm_sess_id + '" />';
	tm    += '<param name="wmode" value="transparent" /> <div></div> </object>';

//	var tm = '<iframe style="color:rgb(0,0,0);float:left;position:absolute;top:-200px;left:-200px;border:0" src="https://images.applyfleet.com/fp/tags?org_id=' + tm_org_id + '&session_id=' + tm_sess_id + '" height=100 width=100></iframe>';
	$('body').prepend(tm);
}

$(document).ready(function(){

	//  Get the program ID
	programname = $('div#OCMSWE-programid').text().trim() || 'not_found';
	getSession();

	//  brand the colors from the options div
	setupBackground();

	//  setup application form
	if ($('div.pgApplicationForm').length && !OCMS.inPageEditor){
		setupApplicationForm();
		setupThreatMetrix();
	}
	//  setup the login form
	if ($('div.pgLogin').length) {
		setupLogin();
	}
	if ($('div.pgAppStatus').length) {
		getAppStatus();
	}
	if ($('div.pgConfirmation').length) {
		confirmAppSubmit();
		getAppStatus();
	}
});

