jQuery.validator.addMethod("phone", function(phone_number, element) {
    phone_number = phone_number.replace(/\s+/g, ""); 
	return this.optional(element) || 
		   phone_number.match(/^[0-9\-_.]+$/);
}, "请输入一个合法的电话号码。");

jQuery.validator.addMethod("post_code", function(post_code, element) {
	return this.optional(element) || 
		   post_code.match(/^\d+$/);
}, "请输入一个合法的邮政编码。");