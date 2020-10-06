/*************************************************************
* ocmsCarousel.js
* v1.0
**************************************************************
* API:
* $(...).ocmsCarousel(opts):
*		Initializes the carousel on the current collection
*		with the specified options.
*		returns: jQuery
*
* $(...).ocmsCarouselInstance()
*		Gets a set of carousel controls.
*		returns: carousel controls
*
* Carousel Controls Instance
*		Supports:
*			start() - start auto-transitions
*			stop() - stop auto-transitions
*           toggle() - toggle auto-transitions
*           isRunning() - returns true if auto-transitions are currently running
*			next() - transition to next item
*			previous() - transition to previous item
*			go(n) - go to item number n. Also takes relative values ('+2', '-4', etc.)
*           getCurrentSlide() - returns a jQuery collection containing the current slide
*           getCurrentIndex() - returns the index of the current slide
*			plugin - direct access to the plugin instance that controls the carousel
*
* $.ocmsCarousel.register(plugin)
*		Registers a plugin that can be used by the core library
*************************************************************
* Plugin API:
* Plugins must implement the following fields:
*		name: A unique name
*		defaults: Default plugin-specific configurations. These will also overwrite global
*			defaults specified in the core library.
*		init(): Any initialization required by the plugin.
*		go(from, to): The core transition function that transitions from one item to another.
*			This is also responsible for updating plugin.current to be the index of the current
*			item in the carousel. It is also responsible for triggering the
*			ocmsCarouselAfterTransition event.
*
* The core plugin API provides the following functions as part of all plugins:
*		globalInit: Common global initialization routines that can be optionally called.
*		getAllSlides: Returns a jQuery collection with all carousel items
*		getSlide(n): Returns a jQuery collection with slide n
*		start: Starts auto-transitions
*		stop: Stops auto-transitions
*       restart: If auto-transitions are running, reset the timer
*       isRunning: returns true if auto-transitions are currently running
*		next: Wrapper for goTo(current+1)
*		previous: Wrapper for goTo(current-1)
*		goTo(n): Wrapper for go(current, n). Supports relative values of n ('+2', '-4', etc.) and
*			performs bounds-checking.
*
* Any of these functions may be overwritten or called by a custom plugin.
*************************************************************
* Global Options:
*	itemSelector: a jQuery selector used within $.find() to get carousel items.
*		Default: li.ocmsCarouselItem
*	plugin: a plugin name
*		Default: slideshow
*	className: a class name stem used by the library
*		Default: ocmsCarouselItem
*	duration: transition duration in ms
*		Default: 1000
*	auto: options for auto-transitions
*		auto.autoStart: Start auto-transitions after initialization
*			Default: true
*		auto.frequency: Auto-transition frequency in ms
*			Default: 4000
*		auto.transitionFunction: Either a function or a string name of a plugin member function that
*			is called for every auto-transition
*			Default: 'next'
*************************************************************
* Events:
* The library uses events to provide extensibility. The core library provides 4 events:
*		ocmsCarouselBeforeInit: Triggered on the carousel container before initialization.
*		ocmsCarouselAfterInit: Triggered on the carousel container after initialization.
*		ocmsCarouselBeforeTransition({from, to}): Triggered on the carousel container before a
*			transition. Handlers can take the from and to indices as parameters.
*		ocmsCarouselAfterTransition({from, to}): Triggered on the carousel container after a
*			transition. Handlers can take the from and to indices as parameters.
*
* The slideshow plugin provides 4 more events. They all provide the index of the affected carousel
* item as a function parameter.
*		ocmsCarouselBeforeShow(idx): Triggered on a carousel item before its show animation begins.
*		ocmsCarouselAfterShow(idx): Triggered on a carousel item after its show animation ends.
*		ocmsCarouselBeforeHide(idx): Triggered on a carousel item before its hide animation begins.
*		ocmsCarouselAfterHide(idx): Triggered on a carousel item after its hide animation ends.
*
* Note that in some cases the 'After' events will not fire, such as when a new transition begins
* before the original animation finishes.
************************************************************/

(function(window, document, $) {
	var W = $(window),
		D = $(document),
		C = $.ocmsCarousel = function($e, options) {
			options = $.extend(true, {}, C.defaults, options);
			options.$container = $e;
			
			if($(options.itemSelector, $e).length == 0) {
				this.success = false;
				this.message = 'No items in carousel.';
				
				return;
			}
		
			if(C.plugins[options.plugin] == undefined) {
				this.success = false;
				this.message = 'Plugin "'+this.options.plugin+'" not found';
				
				return;
			}
			
			var self = this;
			
			this.plugin = $.extend(true, {}, new $.ocmsCarousel.pluginBase(), C.plugins[options.plugin]);
			this.plugin.setOptions(options);
			this.plugin.init();

			this.start = function() { return this.plugin.start(); };
			this.stop = function() { return this.plugin.stop(); };
            this.isRunning = function() { return this.plugin.isRunning(); };
            this.toggle = function() {
                if(self.plugin.isRunning()) {
                    self.plugin.stop();
                    return false;
                } else {
                    self.plugin.start();
                    return true;
                }
            };
			this.next = function() {
                self.plugin.restart();
                return self.plugin.next();
            };
			this.previous = function() {
                self.plugin.restart();
                return self.plugin.previous();
            };
			this.go = function(idx) {
                self.plugin.restart();
                return self.plugin.goTo(idx);
            };

            this.getCurrentSlide = function() { return self.plugin.getSlide(self.plugin.current); };
            this.getCurrentIndex = function() { return self.plugin.current; };
				
			this.success = true;
		};

	$.extend(C, {
		version: '0.1',
		
		defaults: {
			itemSelector: 'li.ocmsCarouselItem',
			plugin: 'slideshow',
			className: 'ocmsCarouselItem',
			duration: 1000,
			auto: {
				autoStart: true,
				frequency: 4000,
				transitionFunction: 'next'
			}
		},
		
		register: function(p) {
			$.ocmsCarousel.plugins[p.name] = p;
		},
		
		plugins: {},
		
		pluginBase: function(e) {
			this.globalInit = function() {
				var $items = this.options.$container.find(this.options.itemSelector);
				var options = this.options;
				$items.each(function(idx) {
					$(this).addClass(options.className+'-'+idx);
				});
				
				this.slideCount = $items.length;
				this.current = 0;
				
				if(this.options.auto.autoStart) {
					this.start();
				}
			};
			
			this.setOptions = function(options) {
				this.options = $.extend(true, {}, this.defaults, options);
			};
			
			this.getAllSlides = function() {
				return this.options.$container.find(this.options.itemSelector);
			};
			
			this.getSlide = function(idx) {
				return this.options.$container.find('.'+this.options.className+'-'+idx);
			};
			
			this.start = function() {
				if(this.timer == undefined) {
					var transitionFunc = this.options.auto.transitionFunction;
					if(typeof transitionFunc != 'function') {
						transitionFunc = this[transitionFunc];
					}
					var plugin = this;
					this.timer = setInterval(function() { transitionFunc.call(plugin); }, this.options.auto.frequency);
				}
			};
			
			this.stop = function() {
				if(this.timer != undefined) {
					clearInterval(this.timer);
				}
				
				delete this.timer;
			};
            
            this.isRunning = function() {
                return (this.timer !== undefined);
            }
            
            this.restart = function() {
                if(this.isRunning()) {
                    this.stop();
                    this.start();
                }
            }
			
			this.next = function() {
				this.goTo('+1');
			};
			
			this.previous = function() {
				this.goTo('-1');
			};
			
			this.goTo = function(idx) {
				var expectedDistance = '';
				var sign = '';
				if(typeof idx == 'string') {
					sign = idx.charAt(0);
					var number = parseInt(idx.substr(1));
					if(sign == '+') {
						idx = this.current + number;
						expectedDistance = number;
					} else if(sign == '-') {
						idx = this.current - number;
						expectedDistance = number;
					}
				}
				
				while(idx < 0) {
					idx += this.slideCount;
				}
				
				idx = idx % this.slideCount;
				
				if(this.current != idx) {
					this.options.$container.trigger('ocmsCarouselBeforeTransition', {from:this.current, to:idx});
				
					this.go(this.current, idx, expectedDistance, sign);
				}
			}
		}
	});
	
	$.fn.ocmsCarousel = function(options) {
		for(var i = 0; i < this.length; i ++) {
			$(this[i]).trigger('ocmsCarouselBeforeInit');
			
			var instance = new C($(this[i]), options);
			$(this[i]).data('instance.ocmsCarousel', instance);
			$(this[i]).trigger('ocmsCarouselAfterInit');
		}
		
		return this;
	};
	
	$.fn.ocmsCarouselInstance = function() {
		return this.length > 0 ? $(this[0]).data('instance.ocmsCarousel') : undefined;
	};
})(window, document, jQuery);

$.ocmsCarousel.register({
	name: 'slideshow',
	
	defaults: {
		minZIndex: 5,
		maxZIndex: 10
	},
	
	init: function() {
		this.globalInit();
		
		this.options.$container.find(this.options.itemSelector)
			.css('z-index', this.options.maxZIndex)
			.not('.'+this.options.className+'-0')
			.css('z-index', this.options.minZIndex)
			.hide();
	},
	
	go: function(from, to) {
		if(from == to) {
			return;
		}
	
		var $from = this.getSlide(from);
		var $to = this.getSlide(to);
		
		if($from.length && $to.length) {
			this.getAllSlides().stop().hide();
			$from.show();
		
			$from.css('z-index', this.options.minZIndex);
			$to.css({'z-index': this.options.maxZIndex,
					'display': 'block',
					'opacity': '0'});
			this.current = to;
			
			$from.trigger('ocmsCarouselBeforeHide', from);
			$to.trigger('ocmsCarouselBeforeShow', to);
			
			var plugin = this;
			$to.animate({opacity: 1.0}, this.options.duration, function() {
				$from.hide();
				$from.trigger('ocmsCarouselAfterHide', from);
				$to.trigger('ocmsCarouselAfterShow', to);
				plugin.options.$container.trigger('ocmsCarouselAfterTransition', {from:from, to:to});
			});
		}
	}
});

$.ocmsCarousel.register({
	name: 'filmstrip',
	
	defaults: {
		visibleItems: 3,
		slideWidth: 150
	},
	
	init: function() {
		this.globalInit();
		
		var width = this.options.slideWidth;

		for(var i = 0; i < this.slideCount; i ++) {
			this.getSlide(i).css('left', (width * i)+'px').data('ocmsCarouselSlideNumber', i);
		}
	},
	
	go: function(from, to, expectedDistance, direction) {
		if(from == to) {
			return;
		}
	
		this.getAllSlides().stop();
	
		var $from = this.getSlide(from);
		var $to = this.getSlide(to);
	
		var leftScrollDistance = from - to;
		var rightScrollDistance = to - from;
		
		while(leftScrollDistance < 0) {
			leftScrollDistance += this.slideCount;
		}
		
		while(rightScrollDistance < 0) {
			rightScrollDistance += this.slideCount;
		}
		
		leftScrollDistance = leftScrollDistance % this.slideCount;
		rightScrollDistance = rightScrollDistance % this.slideCount;
		
		var currentPosition = parseInt($from.css('left'));
		var slideWidth = this.options.slideWidth;
		
		var inc, distance;
		if((leftScrollDistance == expectedDistance && direction == '-') || (!expectedDistance && leftScrollDistance < rightScrollDistance)) {
			inc = -1;
			distance = leftScrollDistance;
		} else {
			inc = 1;
			distance = -rightScrollDistance;
		}
		
		var i;
		for(i = 0; i < this.slideCount; i ++) {
			var newSlide = this.getSlide(i).clone()
				.removeClass(this.options.className+'-'+i)
				.addClass(this.options.className+'-'+i+'dup')
				.insertBefore(this.getSlide(0));
		}
		
		i = from;
		var offset = 0;
		while(i != to) {
			i += inc;
			offset += inc;
			if(i < 0) {
				i += this.slideCount;
			}
			
			i = i % this.slideCount;
			
			this.getClonedSlide(i).css('left', (currentPosition + slideWidth * offset)+'px');
		}
		
		var toPos = parseInt(this.getClonedSlide(to).css('left'));
		for(var i = to; i < to + this.options.visibleItems; i ++) {
			var idx = i % this.slideCount;
			this.getClonedSlide(idx).css('left', (toPos + slideWidth * (i-to))+'px');
		}
		
		var animateDistance = -currentPosition + slideWidth * distance;
		
		this.current = to;
		
		var plugin = this;
		var eventTriggered = false;
		this.getAllSlides().animate({left: '+='+animateDistance}, this.options.duration, function() {
			if(!eventTriggered) {
				plugin.options.$container.trigger('ocmsCarouselAfterTransition', {from:from, to:to});
				eventTriggered = true;
			}
		
			var slideNum = $(this).data('ocmsCarouselSlideNumber');
			if(slideNum != undefined) {
				var $clone = plugin.getClonedSlide(slideNum);
				$(this).css('left', $clone.css('left'));
				$clone.remove();
			}
		});
	},
	
	getClonedSlide: function(idx) {
		return this.options.$container.find('.'+this.options.className+'-'+idx+'dup');
	}
});