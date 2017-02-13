function int_attr(ele, attr_name, default_value) {
	var result = default_value;
	var v = ele.attr(attr_name);
	if (v)
		result = parseInt(v);
	return result;
}

function stripPx(value) {           
	if (value == "") 
		return 0;   
	if (value.indexOf('px') >= 0 || value.indexOf('em') >= 0) {
		return parseFloat(value.substring(0, value.length - 2));                                     
    } else {
		return parseFloat(value);
	}
}

function add_csrf_param(options) {
	var csrf_token = $('meta[name=csrf-token]').attr('content');
	var csrf_param = $('meta[name=csrf-param]').attr('content');
	options[csrf_param] = encodeURI(csrf_token);
	return options
}

var Fusion = {
    select_for_feature: function(default_select, options) {
	if (! options)
	    return default_select;
	return options.select || default_select;
    }
};

var StrippedTable = {
    default_select : 'table.stripped',

    // options should be a jquery select for tables to be apply strip effect.
    init : function(options) {
	var select = options || StrippedTable.default_select;
	$(select + ' tr:even').each (function() {
	    $(this).addClass('even');
	});
    }
};

var AjaxForm = {
    on_submit : function(e) {
	var $t = $(this);
	if (! $t.valid || $t.valid()) {

	    var update = $t.attr('data-update');
		var callback = null;
		var dataType = 'script';
		if (update) {
	    	callback = function(resp) {
				$(update).html(resp);
	    	};
	    	dataType = 'html';
		}
		
		$.ajax($t.attr('action'), 
			  { data: add_csrf_param($t.serialize()), 
			  	type: $t.attr('method'),
			  	success: callback,
			  	dataType: dataType
			  	});
	}
	e.preventDefault();	
    },

    init : function(options) {
	$('form[data-remote=true]').live('submit', AjaxForm.on_submit);
    }
};


var AjaxLink = {
    on_click: function(event) {
	event.preventDefault();
	var $t = $(this);
	var href = $t.attr('href');
	var method = ($t.attr('data-method') || 'get').toUpperCase();
	var update = $t.attr('data-update');
	var callback = null;
	var dataType = 'script';
	if (update) {
	    callback = function(resp) {
		$(update).html(resp);
	    };
	    dataType = 'html';
	}
	
	$.ajax({
	    url: href,
	    type: method,
	    success: callback,
	    dataType: dataType,
	    data: add_csrf_param({})
	});
	return false;
    },

    init: function(options) {
	$(Fusion.select_for_feature('a.remote', options)).live('click', AjaxLink.on_click);	
    }
};

var AjaxPaginate = {
    on_click : function(event) {
	event.preventDefault();
	var ap = $(this).parents('.ajax_paginate');
	var update = $(ap.attr('data-update'));
	var $t = $(this);
	var href = $t.attr('href');
	update.load(href);
    },

    init : function(options) {
	$(Fusion.select_for_feature('.ajax_paginate .pagination a', options)).live('click', AjaxPaginate.on_click);
    }
};

var AjaxCheckbox = {
    default_options: { 
	param_name : 'checked',	
    },

    on_change: function(event) {
	var $t = $(this);
	var param_name = $t.attr('data-param-name') || AjaxCheckbox.default_options.param_name;
	var params = {};
	params[param_name]= this.checked;
	var params = add_csrf_param(params);
	$.post($t.attr('data-url'), params);
    },

    init : function (options) {
	$(Fusion.select_for_feature('input[type=checkbox].remote',options)).live('change', this.on_change);
    }
};

var AjaxDelete = {
    on_click : function(event) {
	event.preventDefault();
	var href = $(this).attr('href');
        var confirmed;
        if ($(this).attr('data-noconfirm')) {
            confirmed = true;
        } else { 
	    var msg = $(this).attr('data-confirm-message') || '确定要删除吗?';
            confirmed = window.confirm(msg, '是', '再考虑一下');
        }
        if ( confirmed ) {
	    $.post(href, add_csrf_param({ '_method' : 'delete' }) );
        }
    },

    init : function(options) {
	$(Fusion.select_for_feature('a.delete', options)).live('click', AjaxDelete.on_click);
    }
};

var InputHint = {
    on_focus : function() {
	$(this).removeClass('inactive');
	if ($(this).val() == $(this).data('hint') || '') {
	    $(this).val('');
	}
    },

    on_blur : function() {
	var hint = $(this).data('hint');
	if ( $(this).val () == '') {
	    $(this).addClass('inactive');
	    $(this).val(hint);
	}
    },

    init : function(options) {
	$(Fusion.select_for_feature('input.hint', options)).each(function(){
	    $(this)
		.data('hint', $(this).val())
		.addClass('inactive')
	        .focus(InputHint.on_focus)
		.blur(InputHint.on_blur);
	});
    }
};

var LinkToSubmit = {
    on_click : function (event) {
	event.preventDefault();
	var $t = $(this);
	var form = null;
	if ($t.attr('data-form')) {
	    form = $($t.attr('data-form'));
	} else {
	    form = $t.parents('form');
	}

	form.trigger('submit');
    },

    init: function(options) {
	$(Fusion.select_for_feature('a.submit', options)).live('click', LinkToSubmit.on_click);
    }
};

var ValidableForm = {
    init: function(options) {
	$(Fusion.select_for_feature('form.validable', options)).each (function(i, f) {$(f).validate()});
    }
};

var RemoteDialog = {
    load: function(url, title) {
	$('#dialog > .body').load(url, function() {
	    $('#dialog').dialog("option", "title", title);
	    $('#dialog').dialog("open");
	});
    },

    init: function(options) {
	$(Fusion.select_for_feature('a.dialog_trigger', options)).live('click', function(e) {
		e.preventDefault();
		var $t = $(this);
		var url = $t.attr('href');
		var title = $t.attr('data-title');
		RemoteDialog.load(url, title);
		return false;
	    });
    }
};

var InitDatepicker = {
    default_options : {
	dateFormat: 'yy-mm-dd'	
    },

    init: function(options) {
	$(Fusion.select_for_feature('input[type=text].date-field'), options).each (function(i, f){
	    var ops = $.extend({}, InitDatepicker.default_options);
	    var $f = $(f);
	    if ( $f.attr('data-min-date')) {
		ops.minDate = $f.attr('data-min-date');
	    }
	    if ( $f.attr('data-max-date')) {
		ops.maxDate = $f.attr('data-max-date');
	    }
	    if ( $f.attr('data-format')) {
		ops.dateFormat = $f.attr('data-format');
	    }
	    $f.datepicker(ops);
	});
    }
};

var RequiredMark = {
    init: function(options) {
	$(Fusion.select_for_feature('input[type=text].required, textarea.required', options)).
	    parents('fieldset').find('label.form-label').append('<span class="required_mark">*</span>');
	    /* each(function(f, l) {
		var $l = $(l);
		var h = $l.html();
		$l.html(h + '<span class="required_mark">*</span>'); 
	    });*/
    }  
};

$.extend(Fusion, {
    DEFAULT_FEATURES : [AjaxForm, AjaxLink, AjaxPaginate, StrippedTable, AjaxCheckbox, AjaxDelete, ValidableForm, LinkToSubmit, RequiredMark, RemoteDialog],

    use_feature : function(feature, options) {
	feature.init(options);
    },

    use_default_features: function() {
	$.each(Fusion.DEFAULT_FEATURES, function(index, feature) {
	    Fusion.use_feature(feature)
	});
    }
});

