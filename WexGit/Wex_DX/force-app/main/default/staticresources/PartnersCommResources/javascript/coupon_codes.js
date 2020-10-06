
/**
 * Check to see if coupon code values exist and apply theme to coupon code targets
 */

(function($) {
  Drupal.behaviors.wexCouponCodes = {
    attach: function(context, settings) {
      var values = this.getFieldValues();
      var params = "", names = "";

      for (var prop in values) {
        name = encodeURIComponent(prop);
        names  += "|" + name;
        params += "&" + name + "=" + encodeURIComponent(values[prop]);
        
        //check for form values that have the same names / id's to auto fill
        $("form #edit-submitted-" + prop + ", form input[name$='" + prop + "]'], form input[name$='" + prop + "']", context).each(function() { 
          $(this).val(values[prop]);
        });
      }

      // Updates all the coupon codes for links that are coupon code targets.
      if (params.length > 0) {
        params = params.substr(1);
        var pattern = new RegExp("[&\?](" + names.substr(1) + ")", "i");

        // Modify URI's to contain the coupon code parameters.
        $("a.couponcodetarget", context).each(function(index) {
          link = $(this).attr("href");
          if (!pattern.test(link)) {
            // append to an already existing GET query, or start one.
            link += ((link.indexOf('?') >= 0) ? '&' : '?') + params;
            $(this).attr("href", link);
          }
        });
      }
    },
    getFieldValues: function() {
      if (Drupal.behaviors.wexCouponCodes.fieldValues === undefined) {
        var values = {}, value;
        var settings = Drupal.settings.coupon_codes || {};
        var fields = settings.fields || ['couponCode'];
        
        for (var i = 0; i < fields.length; ++i) {
          if (value = $.cookie(fields[i]))
            values[fields[i]] = value;
        }

        // Set the default code if still missing a value
        if (fields[0] && !values[fields[0]] && settings.defaultCode) {
          values[fields[0]] = settings.defaultCode;
        }
        Drupal.behaviors.wexCouponCodes.fieldValues = values;
      }
      return Drupal.behaviors.wexCouponCodes.fieldValues;
    }
  }

  $(document).ready(function() {
	if (!Drupal.settings.coupon_codes)
      return;

	var settings = Drupal.settings.coupon_codes;
	if (settings.pageTrackEvent) {
      try {
        if (pageTracker) {
          var params = "";
          var values = Drupal.behaviors.wexCouponCodes.getFieldValues();

          for (var prop in values) {
            params += "&" + name + '=' + values[prop];
          }
          pageTracker._trackEvent("coupon_codes", settings.pageType, params);
        }
      }
      catch(e) { };
	}
  });
  
} (jQuery));