/*  ocms-signInTransmogrifier.js

    - transmogrify Orchestra portal sign-in table markup into something else

    2012-Jul-03  dwl  created definitive version for PSTools; largely, if not entirely, cleaned up
    2011-Mar-08  dwl  now with support for returning error messages, but this version still hard-wired
	    		      for sign in portal panel only

    Sample Use
    ~~~~~~~~~~
		OCMS.signInTransmogrifier({
			selector: $signInContainer,
			newTemplate: '<p>{userLabel}{user}</p><p>{passwordLabel}{password}</p><p>{signIn}</p><p>{forgot}</p><div class="signInError" data-errorcode="{errorMessageClass}">{errorMessage}</div>',
			addClasses: true,
			text: {
				signIn: 'Sign In',
				forgot: 'Forgot Password?'
				}
		});

        - returns a list of ids for:
            - user name text box
            - password text box
            - sign in button
            - forgot password span that encloses the anchor
        - for accessibility, don't omit labels; use text: {...} to provide alternative text if needed

        Parameters
        - selector (jQuery collection or selector string) that contains an Orchestra Portal
          sign in table (and no other tables!); does not have to be a child, just a descendent
        - if newTemplate (string) is not provided, function still returns the array of ids
        - include addClasses: true (recommended) to have lblUser, txtUser, lblPassword, txtPassword,
          butSignIn, and forgotPassword classes added to the corresponding elements
        - supported 'text' properties:
            - userLabel (label for user name text box)
            - passwordLabel (label for password text box)
            - signIn (the submit button)
            - forgot (forgot your password link text)
*/

var OCMS;

try {

    if (!OCMS) {
        OCMS = {};
    }

    (function ($) {
        OCMS.signInTransmogrifier = function (args) {

            var selector = args.selector || args,
                newTemplate = args.newTemplate || null;

            var	settings = {
                    addClasses: false,
                    text: {
                        userLabel: null,
                        passwordLabel: null,
                        signIn: null,
                        forgot: null
                    }
                };

                // if !args.newTemplate, we'll assume they passed a single string or jQ selector
                if (args.newTemplate) {
                    $.extend(true, settings, args);
                }

            var	$signin = null,
                newSignIn = '',
                ids = [],
                $tds = null,
                tdsContent = [],
                $errDiv = null,
                $errMsgDiv = null,
                errorClass = '',
                errorMessage = '';


            $signin = $(selector);
            if ($signin.size() === 1) {

                // before we gather up td's into this jQuery collection, look for, save, and
                // then remove the error message information
                // if present, it will be in a table that precedes the regular sign in table in the DOM

                $errDiv = $signin.find('div.message');
                if ($errDiv.length === 1) {
                    errorClass = $errDiv.removeClass('message').attr('class');
                    $errMsgDiv = $errDiv.find('div.messageText');
                    $errMsgDiv.find('span').remove().end()
                            .find('h4').remove().end()
                            .find('br').remove();
                    errorMessage = $errMsgDiv.text().trim();
                    // English-specific brute force changing "username" to "user name"
                    errorMessage.replace(/sername/, 'ser name');
                    // errorMessage and errorClass will be appended to tdsContent[] later
                    $errDiv.remove();
                } else {
                    // NOT SUPPORTED -- Sign In page only, please!
                    // perhaps it's a change password form (different div.class)
//                         $errDiv = $signin.find('cp-errors');
//                         if ($errDiv.length === 1) {
//                             errorMessage = $errMsgDiv.text().trim();
//                             $errDiv.remove();
//                         }
                }

                $tds = $signin.find('td');
                var fieldInfo = [
                        { /* 0 userLabel: */
                            text: settings.text.userLabel,
                            clas: 'lblUser'
                        },
                        {   /* 1 user: */
                            text: settings.text.user,
                            clas: 'txtUser'
                        },
                        { /* 2 passwordLabel: */
                            text: settings.text.passwordLabel,
                            clas: 'lblPassword'
                        },
                        {	/* 3 password: */
                            text: settings.text.password,
                            clas: 'txtPassword'
                        },
                        {	/* 4 signIn: */
                            text: settings.text.signIn,
                            clas: 'butSignIn'
                        },
                        {   /* 5 forgot: */
                            text: settings.text.forgot,
                            clas: 'forgotPassword'
                        }
                ];

                // skip over empty cells, so the td's we visit will match fieldInfo[] above
                $tds.filter(function () {
                        return $(this).children().length;
                    })
                    .each(function (nIt) {
                        var $this = $(this),
                            info = fieldInfo[nIt],
                            $el;

                        $el = $(':first-child', $this);
                        if ($el.attr('id')) {
                            ids.push($el.attr('id'));
                        }

                        if (settings.addClasses) {
                            $el.addClass(info.clas);
                        }

                        if (typeof info.text === 'string') {
                            // Yes, we have hard wires!
                            switch (nIt) {
                                case 0:     // username label
                                case 2:     // password label
                                    $('label', this).text(info.text);
                                    break;

                                case 4:     // input[type="submit"]
                                    $('input', this).val(info.text);
                                    break;

                                case 5:     //
                                    $('a', this).text(info.text);
                                    break;

                                default:
                                    // not supported for 1, 3: input[type="text|password"]
                            }
                        }
                    });

                if (newTemplate) {
                    // copy the contents of each td into an array for insertion into the template
                    $tds.each(function (nIt) {
                        tdsContent.push($(this).html());
                    });
                    tdsContent.push(errorMessage);		// 10
                    tdsContent.push(errorClass);		// should be at offset 11 -- **currently meaningless**

/*
    - currently hard-wired for the Sign In portal panel
    - could be extended to support two flavours of change password as well as forgot password
    - ...but see ocms-extensions for jQuery operators for tables:
    -   detableChangePasswordOldUser
    -   detableChangePasswordNewUser
    -   detableForgotPassword
*/

                    var numerics = {
                        userLabel: 			'{0}',
                        user: 				'{1}',
                        passwordLabel: 		'{2}',
                        password: 			'{3}',
                        signIn: 			'{5}',
                        forgot: 			'{9}',
                        errorMessage: 		'{10}',
                        errorMessageClass:	'{11}'
                    };

                    // change the text targets, like '{signIn}' in the provided template to
                    // their numeric position in the tdsContent array
                    newTemplate = newTemplate.supplant(numerics);

                    // create new sign in markup from template and original content
                    newSignIn = newTemplate.supplant(tdsContent);

                    // update the DOM with the new markup
                    $signin.find('table').replaceWith(newSignIn);
                }
            } else {
                OCMS.consoleMsg('signInTransmogrifier: sign in table not found');
            }

            return {
                ids: {
                    user: ids[0],
                    password: ids[1],
                    signIn: ids[2],
                    forgot: ids[3]
                }
            }
        }	// signInTransmogrifier
    })(jQuery);
} catch (ex) {
    if (console.log) {
        console.log('ocms-signInTransmogrifier: ', ex);
        if (ex.type) {
            console.log('\t' + ex.type);
        }
        if (ex.arguments && ex.arguments.length) {
            for (var nIt = 0; nIt < ex.arguments.length; ++nIt) {
                console.log('\t' + ex.arguments[nIt]);
            }
        }
    }
}