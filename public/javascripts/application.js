$(document).ready(function() {
	
	//Taken from http://jquery-ui.googlecode.com/svn/trunk/ui/i18n/jquery.ui.datepicker-en-GB.js
	
	$.datepicker.regional['en-GB'] = {
			closeText: 'Done',
			prevText: 'Prev',
			nextText: 'Next',
			currentText: 'Today',
			monthNames: ['January','February','March','April','May','June',
			'July','August','September','October','November','December'],
			monthNamesShort: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
			'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
			dayNames: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
			dayNamesShort: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
			dayNamesMin: ['Su','Mo','Tu','We','Th','Fr','Sa'],
			weekHeader: 'Wk',
			dateFormat: 'dd/mm/yy',
			firstDay: 1,
			isRTL: false,
			showMonthAfterYear: false,
			yearSuffix: ''};
		$.datepicker.setDefaults($.datepicker.regional['en-GB']);
	
	$(".delete_button").each(function(){
		$(this).button({
           	icons: {
                primary: 'ui-icon-closethick'
            }
		})
    })
	$(".show_button").each(function(){
		$(this).button({
           	icons: {
                primary: 'ui-icon-search'
            }
		})
    })
    $(".edit_button").each(function(){
		$(this).button({
           	icons: {
                primary: 'ui-icon-wrench'
            }
		})
    })
	$(".new_button").each(function(){
		$(this).button({
           	icons: {
                primary: 'ui-icon-plusthick'
            }
		})
    })
	$(".footprint_report_button").each(function(){
		$(this).button({
           	icons: {
                primary: 'ui-icon-plusthick'
            }
		})
    })
	
	$(".back_button").each(function(){
		$(this).button({
           	icons: {
                primary: 'ui-icon-circle-triangle-w'
            }
		})
    })
	$(".blank_button").button();
	$(".submit_button").button();
	$(".datepicker").datepicker();
    $("#notice:empty").hide();
	$("#accordion_active").accordion({
		autoHeight: false,
		header: ".header",
		animated: 'quad',
		event: "click"
	});
	
	$("#accordion").accordion({
		autoHeight: false,
		header: ".header",
		animated: 'quad',
		event: "click",
		active: false
	});
	$( "#dialog" ).dialog({
		autoOpen: false,
		show: "blind",
		hide: "explode"
	});
});

function generate_document_uploads_query_url(date, source_type) {
	return "/document_uploads/list?date=" + date + "&" + "source_type="+ source_type;
}