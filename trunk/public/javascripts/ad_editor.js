var Resources = {
    resources : [],

    serialize_resource_ids: function() {
	var ids = '';
	$.each(Resources.resources, function(i, res) {
	    if (ids && ids != '') 
		ids = ids + ',';
	    ids = ids + res.resource_id;
	});
	return ids;
    },

    remove_resource_of_name: function(name) {
	for (i=0; i< Resources.resources.length; ++i) {
	    if (Resources.resources[i].name == name) {
		this.resources.splice(i,1);
		return;
	    }
	}	
    },

    remove_resource_of_name_and_size: function(name, size) {
	for (i=0; i< Resources.resources.length; ++i) {
	    if (Resources.resources[i].name == name &&
	        Resources.resources[i].size == size ) {
		this.resources.splice(i,1);
		return;
	    }
	}		
    },

    find_by_name: function(name) {
	for (i=0; i< this.resources.length; ++i) {
	    if (this.resources[i].name == name) {
		return this.resources[i];
	    }
	}		
    },
    
    find_by_name_and_size: function(name, size) {
	for (i=0; i< this.resources.length; ++i) {
	    if (this.resources[i].name == name &&
	        this.resources[i].size == size ) {
		return this.resources[i];
	    }
	}		    
	return null;
    },
    
    add : function(res) {
	Resources.resources[Resources.resources.length] = res;
    },

    remove: function(res) {
	for (i=0; i< this.resources.length; ++i) {
	    if (this.resources[i].resource_id == res.resource_id) {
		this.resources.splice(i,1);
		return;
	    }
	}
    },
    
    clear: function() {
	this.resources.length=0;
    }
};

var format_icon_text = {
    has_enough_resources: function() {
	var icon = Resources.find_by_name('icon');
	return icon != null;
    },

    resource_uploaded: function(resp_json) {
	$('div.ad_preview .' + resp_json.name + ' img').attr('src', resp_json.url);
	Resources.remove_resource_of_name(resp_json.name);
	Resources.add(resp_json);
    }
};

var format_image = {
    has_enough_resources: function() {
	var image = Resources.find_by_name('image');
	return image != null;
    },

    resource_uploaded: function(resp_json) {
	var oldResource = Resources.find_by_name_and_size(resp_json.name, resp_json.size);
	if (oldResource) {
	    $('.ad_preview.image div#resource_' + oldResource.resource_id).remove();
	    Resources.remove(oldResource);
	}
	var newImage = $('.ad_preview.image .template').clone().removeClass('template');
	newImage.find('img').attr('src', resp_json.url);
	newImage.find('a').attr('href', '/ad_owner/ad_resources/' + resp_json.resource_id + '.js')
	    .attr('data-id', resp_json.resource_id);
	newImage.attr('id', 'resource_' + resp_json.resource_id).appendTo('.ad_preview.image');
	Resources.add(resp_json)
    }
}

var AD_FORMATS = {
    'icon_text' : format_icon_text,
    'image' : format_image
};

function delete_ad_resource(event) {
    event.preventDefault();
    var id = $(this).attr('data-id');
    $('.ad_preview #resource_' + id).remove();
    Resources.remove({resource_id: id});
}

function upload_resource_error (e, id, file, error) {
    alert('上传资源时发生错误:' + error.info);
}

function resource_uploaded (e, id, file, response, data) {
    var resp_json = $.parseJSON(response);
    if (resp_json.error) {
	alert (resp_json.error);
    } else {
	var ad_format_name = resp_json['format']
	var ad_format = AD_FORMATS[ad_format_name];
	ad_format.resource_uploaded(resp_json);
    }
}

function text_resource_changed(e) {
    var $t = $(this);
    var res_name = $t.attr('data-resource-name');
    $('div.ad_preview p.' + res_name).html($t.val());
}

function uploadify_resource(select, ad_format, resource_name, session_key_name, session_id, sizelimit) {
    if (! sizelimit)
	sizelimit = 102400;
    var script_data = { resource_name: resource_name};
    script_data[session_key_name] = session_id;
    var csrf_token = $('meta[name=csrf-token]').attr('content');
    var csrf_param = $('meta[name=csrf-param]').attr('content');
    script_data[csrf_param] = encodeURIComponent(encodeURIComponent(csrf_token));

    $(select).uploadify({
	buttonImg: '/images/select_file.png',
	uploader: '/uploadify/uploadify.swf',
	script: '/ad_owner/ad_resources/' + ad_format + '/upload.json',
        cancelImg: '/uploadify/cancel.png',
        folder: '/tmp/uploaded',
	auto: true,
	scriptData : script_data,
	fileDataName: 'resource_file',
	onError: upload_resource_error,
	onComplete: resource_uploaded,
	sizeLimit: sizelimit
    });
}

function ad_resource_deleted(id) {
    Resources.remove({resource_id: id});
    $('.ad_preview div#resource_' + id).remove();
}

function current_format() {
    var format_name
    if (AD_FORMAT_NAME != undefined )
	format_name = AD_FORMAT_NAME;
    else
	format_name = $('#advertisement_ad_format').val();
    return AD_FORMATS[format_name];
}

function on_submit_advertisement() {
    if (! current_format().has_enough_resources()) {
	alert ('缺少必要的媒体资源。');
	return false;
    }
    $('#resource_ids').val(Resources.serialize_resource_ids());
    return true;
}

function calculate_total_budget() {
    var sum = 0;
    $('td.ag_total_budget').each(function(i, ele){
	var daily_budget = parseFloat($(ele).html());
	if ( ! isNaN(daily_budget)) 
	    sum += daily_budget;
    });
    $('#total_budget').html(Math.ceil(sum));
}

function calculate_total_daily_budget() {
    var sum = 0;
    $('input.daily_budget').each(function(i, ele){
	var daily_budget = parseFloat($(ele).val());
	if ( ! isNaN(daily_budget)) 
	    sum += daily_budget;
    });
    $('#total_daily_budget').html(Math.ceil(sum));
    calculate_total_budget();
}

function on_change_daily_budget(e) {
    var publish_policy_id = parseInt($(this).attr('data-id'));
    var daily_budget = $(this).val();
    var day_number = parseInt($('#publish_policy_' + publish_policy_id + '_day_number').html());
    if (! isNaN(day_number) && ! isNaN(daily_budget)) {
	$('#publish_policy_' + publish_policy_id + '_total_budget').html(Math.ceil(daily_budget * day_number));
    }    
    calculate_total_daily_budget();
}

function on_change_effect(e) {
    var publish_policy_id = parseInt($(this).attr('data-id'));
    var unit = parseInt($(this).attr('data-unit'));
    var effect = parseInt($(this).val());
    var bid_price = parseFloat($('#publish_policies_' + publish_policy_id + '_bid_price').val());
    var daily_budget = effect / unit * bid_price;
    $('#publish_policies_' + publish_policy_id + '_daily_budget').val(daily_budget);
    var day_number = parseInt($('#publish_policy_' + publish_policy_id + '_day_number').html());
    if (! isNaN(day_number) && ! isNaN(daily_budget)) {
	$('#publish_policy_' + publish_policy_id + '_total_budget').html(Math.ceil(daily_budget * day_number));
    }
    calculate_total_daily_budget();
}

function on_change_bid_price(e) {
    var publish_policy_id = parseInt($(this).attr('data-id'));
    var unit = parseInt($(this).attr('data-unit'));
    var effect = parseInt($('#publish_policies_' + publish_policy_id + '_effect').val());
    var bid_price = parseFloat($(this).val());
    var daily_budget = effect / unit * bid_price;
    var day_number = parseInt($('#publish_policy_' + publish_policy_id + '_day_number').html());
    if (! isNaN(day_number) && ! isNaN(daily_budget)) {
	$('#publish_policy_' + publish_policy_id + '_total_budget').html(Math.ceil(daily_budget * day_number));
    }
    $('#publish_policies_' + publish_policy_id + '_daily_budget').val(daily_budget);    
    calculate_total_daily_budget();
}

$(function(){
    $('input[type=text].text_resource').live('change', text_resource_changed);

    $('form#advertisement_form').submit(on_submit_advertisement);
    
    $('a.delete_ad_resource').live('click', delete_ad_resource);

    $('#publish_policy_bid_price').change(function(e){
	var price = $(this).val();
	var paymethod_id = $(this).attr('data-paymethod-id');
	if ('' == price) {
	    $('#compare_price_result').html('');
	} else {
	    $('#compare_price_result').load('/ad_owner/publish_policies/compare_price.html?price=' + $(this).val() + '&pay_method_id=' + paymethod_id);
	}
    });

    $('input.effect').change(on_change_effect);
    $('input.bid_price').change(on_change_bid_price);
    $('input.daily_budget').change(on_change_daily_budget);
});