$.fn.slide = function(action) {
    var element = this;

    function show_slide_at(idx) {
	element.find('.slide.current').hide().removeClass('current');
	element.find('.slide:eq(' + idx + ')').show().addClass('current').slideDown();
    }

    function previous_slide () {
	var cur_index = element.data('current_index');
	cur_index -= 1;
	if (cur_index < 0)
	    element.cur_index = element.data('count') - 1;
	
	this.data('current_index', cur_index);
	show_slide_at(cur_index);
    }

    function next_slide() {
	var cur_index = element.data('current_index');
	var count = element.data('count');

	cur_index += 1;
	if (cur_index >= count)
	    cur_index = 0;

	element.data('current_index', cur_index);
	show_slide_at(cur_index);	
    }
    
    if ('next' == action) {
	next_slide();
    } else if ('prev' == action) {
	previous_slide();
    } else {
	var slides = $('.slide');
	element.data('count', slides.size());
	element.data('current_index', 0);
	show_slide_at(0);
    }
};

