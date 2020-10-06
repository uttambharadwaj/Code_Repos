/*
 * WEX Namespace
 * Method method - The ability to add a method to $.WEX
 *
 * @author: Ben Babics
 * @access: public
 * @return: $.WEX
*/
$.WEX = {
    method: function(key, fn) {
        if (key != undefined && typeof key === 'string')
            if (typeof fn === 'object' || typeof fn === 'function')
                this[key] = fn;
        return this;
    }
};


/*
 * Custom Events
 * @author: Ben Babics
*/
;(function(window, $, undefined) {
    var CustomEvent = function(name) {
        this.subscribers = [];
        this.name        = name;
    };
    CustomEvent.prototype = {
        bind: function(fn) {
            this.subscribers.push(fn);
        },
        trigger: function() {
            for (var i=0; i < this.subscribers.length; i++) {
                var fn = this.subscribers[i];
                if (typeof fn === 'function') fn.apply(null, arguments);
            }
        }
    };

    var events = {};
    function bind(name, fn) {
        if (name && typeof name === 'string') {
            if (events[name] == null)
                events[name] = new CustomEvent(name);
            if (fn != null)
                events[name].bind(fn);
        }
        return this;
    }
    function trigger(name) {
        if (name && typeof name === 'string')
            if (events[name] != null && typeof events[name].trigger === 'function')
                events[name].trigger.apply(events[name], arguments);
        return this;
    }

    /*
     * Bind Custom Event
     *
     * @access: public
     * @param : string, e.g. "form:submit"
     * @param : function (callback)
     * @return: $.WEX
    */
    $.WEX.method('bind', bind);

    /*
     * Trigger Custom Event
     *
     * @access: public
     * @param : string, e.g. "form:submit"
     * @param : object litteral, e.g. {foo:"bar"}
     * @return: $.WEX
    */
    $.WEX.method('trigger', trigger);
})(this, jQuery);


/*
 * Form field filter & masking
 * @author: Ben Babics
 * [http://jsfiddle.net/bbabics/DPwA7/]
 *
 * <input type="text" data-mask="99/99/9999">
 * <input type="text" data-alpha="!@#$%^&*()">
 * <input type="text" data-alphanumeric="!@#$%^&*()">
*/
$('.ui-page').live('pageinit', (function() {
    var ATTRS = "mask alpha numeric alphanumeric".split(' ');

    function extend(method, option) { // if option is an object literal each statement can hook into specifc data-attr values
        switch(method) {
            case "mask":
                return (option || 'aaaa').toString();
            break;

            case "numeric":
                return {allow: option || ""}
            break;

            case "alpha":
            case "alphanumeric":
                return {allow: option || "~&_+`-{}|':,./"};
            break;
        }
    }

    $.extend($.mask.definitions, {
        "1": "[01]"
    });

    function delegate(method, $fields) {
        $fields.each(function() {
            var $field = $(this),
                option = $field.data(method); // enhance by removing method arg
            $field[method](extend(method, option));
        });
    }

    function addFilter(attr, $field) {
        if ( $.inArray(attr, ATTRS) >= 0 )
            delegate(attr, $field);
    }

    return function() {
        var page = this;
        $.each(ATTRS, function(n, attr) {
            addFilter(attr, $('.field-'+attr, page) );
        });
    }
}()));


/*
 * Form field validation & custom rules
 * using HTML5 data-* attrs for validation
 *
 * @example HTML: <input type="text" data-required>
 * @example JS  : $.WEX.validate();
 *
 * @example custom rule:
 * $.WEX.expect({
 *     page : "information"
 *     field: "#first_name",
 *     rule : function(val) {
 *         return {
 *             isValid: val != "foobar",
 *             message: "value cannot be 'foobar'."
 *         }
 *     }
 * });
 *
 * @author: Ben Babics
 * @access: public
 * @return: Boolean
*/
$('.ui-page').live('pageinit', (function() {
    var Fieldset, Field, Manager;

    Fieldset = function($page) {
        this.$el     = $page;
        this.$fields = $([]);
        return this.init();
    };
    Fieldset.prototype = {
        expect: function(data) {
            this.$fields.each(function() {
                if ( this.$el.is(data.field) )
                    this.expect(data.rule);
            });
            return this;
        },
        init: function() {
            var $fields = this.$fields;
            $('.field-required, :jqmData(required)', this.$el).each(function() {
                $fields.push( Manager.create(this) );
            });
            return this;
        },
        render: function() {
            var list = [];
            $.each(this.validate(), function() {
                list.push({
                    field  : this.render(),
                    message: this.message
                });
            });
            return list;
        },
        validate: function() {
            var fields = [];
            this.$fields.each(function() {
                var field = this.validate();
                if (!field.isValid)
                    fields.push( $.extend({}, this, field) );
            });
            return fields;
        }
    };

    Field = function($input) {
        this.requires = [];
        this.$el    = $input;
        this.$label = this.$el.closest(':jqmData(role="fieldcontain")').children('label');

        return this.init();
    };
    Field.prototype = {
        expect: function(rule) {
            if ( $.isFunction(rule) )
                this.requires.push(rule);
            return this;
        },
        init: function() {
            this.$label.append('<span class="required">*</span>');

            // presence_of rule
            this.expect(function(val) {
                return {
                    isValid: val != "",
                    message: "must have a value."
                }
            });

            return this;
        },
        render: function() {
            return this.$label.text().replace(':*','');
        },
        validate: function() {
            var rule, self = this;
            $.each(this.requires, function(n, fn) {
                rule = fn( $.trim( self.$el.val() ) );
                if (!rule.isValid) return false;
            });
            return rule;
        }
    };

    Manager = {
        data: {},
        requires: {},
        add: function(page) {
            var self = this;

            if (self.data[page.id] == null)
                self.data[page.id] = self.create(page);

            if (self.requires[page.id] != null) {
                $.each(self.requires[page.id], function(n, rule) {
                    self.data[page.id].expect(rule);
                });
            }
        },
        get: function(id) {
            return this.data[id];
        },
        expect: function(data) {
            if (data.page == null) return this;

            if ( this.get(data.page) )
                this.get(data.page).expect({
                    "field": data.field,
                    "rule" : data.rule
                });

            else {
                if (this.requires[data.page] == null)
                    this.requires[data.page] = [];

                this.requires[data.page].push({
                    "field": data.field,
                    "rule" : data.rule
                });
            }
        },
        create: function factory(el) {
            var $el = $(el);

            if ($el.is('div:jqmData(role=page)'))
                return new Fieldset($el);

            else if ($el.is(':input'))
                return new Field($el);
        }
    };


    $.WEX.method('expect', function(rules) {
        // allow loading of DOM
        return $(function() {
            rules = $.isArray(rules) ? rules : [rules];

            $.each(rules, function(n, rule) {
                Manager.expect(rule);
            });
        });
    });


    $.WEX.method('validate', function() {
        var page   = $.mobile.activePage.attr('id'),
            errors = Manager.get(page).render();

        if (errors.length)
            $.WEX.trigger('validate:invalid', errors);

        return errors.length ? false : true;
    });


    return function() {
        Manager.add(this);
    }
}()));


/*******************************************************************************
**** Validation
*******************************************************************************/
$.WEX.bind('validate:invalid', (function() {
    var viewModel = {
        errors : "",
        message: "Validation error.",
        title  : "Cannot complete request"
    };

    function request() {
        var role = {role:"dialog"};
        $('#validation-title').text(viewModel.title);
        $('#validation-message').text(viewModel.message);
        $('#validation-errors').html(viewModel.errors);
        $.mobile.changePage( $('#validation'), role );
    }

    function populateMessage() {
        var text    = viewModel.errors.length > 1 ? "s are" : " is",
            message = ['The following field',' required:'].join(text);
        viewModel.message = message;
    }

    function populateErrors(errors) {
        viewModel.errors = "";
        $(errors).each(function() {
            var field   = this.field,
                message = this.message;
            viewModel.errors += "<li><em>\""+field+"\"</em> "+message+"</li>";
        });
    }

    return function(evt, errors) {
        populateErrors(errors);
        populateMessage();
        request();
    }
}()));