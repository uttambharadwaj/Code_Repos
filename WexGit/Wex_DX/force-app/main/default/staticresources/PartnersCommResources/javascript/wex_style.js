
(function($) {

	  
  Drupal.behaviors.wexSiteSearch = {
    attach: function(context, settings) {
      $('#search-block-form input[type=text], #edit-search-block-form--2', context).each(function() {
        $(this).focus(function() {
          if ($(this).hasClass('placeholder')) { 
            $(this).val('').removeClass('placeholder');
          }
        });
        $(this).blur(function() {
          if ($.trim($(this).val()) == '') {
            $(this).addClass('placeholder').val('SITE SEARCH');
          } 
        });
        $(this).val('').trigger('blur');
	  });
    }
  }  
  
  Drupal.behaviors.equalPostscriptRegions = {
    attach: function(context, settings) {
      var maxHeight = 0;
      $('#zone-postscript .region-inner', context).each(function() {
        maxHeight = Math.max(maxHeight, $(this).height());
      });
 
      $('#zone-postscript .region-inner', context).each(function() {
        var diff = Math.max(maxHeight - $(this).height(), 0);
       
        // Make-up the height difference only in the last block in the region.
        var block = $(this).find('.block-inner').last();
        var content = block.find('.content');
        content.height(content.height() + diff);

        content.find('a.button, a.more-link, a.views-more-link, input[type=submit], button')
          .last().css({ top: block.height() - 30 });
      });
    }
  }

  $(function() {
    $('#block-system-main-menu .content > ul.menu > li.expanded').hover(
      function () {
        $(this).find('ul.menu:first').show();
      }, 
      function () {
        $(this).find('ul.menu:first').hide();
      }
    );
  });

  /** For Lower HOMEPAGE Boxes **/
    
  /*
  var box2height = $('#region-postscript-second').height();
  var box2TextLength = $('#region-postscript-second div.content p').text().length;
		
  // Set Box1 Height 
  $('#region-postscript-first .item-list ul').css("height", box2height-37 + 'px');
	
  // Truncate Box1 Text
  var feedText = $('#region-postscript-first .item-list ul li p').text();
  var feedTextShort = jQuery.trim(feedText).substring(0, box2TextLength)
	    .split(" ").slice(0, -1).join(" ") + "...";
		
		$('#region-postscript-first .item-list ul li p').text(feedTextShort);
		
				
		// Set Box3 Height 
		$('#region-postscript-third div.block-inner > div.content').height(box2height-56);
		*/
})(jQuery);