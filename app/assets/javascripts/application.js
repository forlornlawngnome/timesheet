// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require twitter/bootstrap
//= require_tree .
//= require local-time
//= require moment
// require turbolinks
//= require jquery.ui.datepicker
//= require jquery-ui-timepicker-addon
//= require jquery.ui.slider
//= require cocoon

jQuery(function(){
	return $('.data_table').dataTable({
		"dom": "<'small-6 columns float-left datatables_style'f><'small-4 columns'><'small-6 columns float-right datatables_style'li>r"+"t"+"<'float-right'p>",
		"lengthMenu": [[20,35,50,-1], [20,35,50,"All"]]
	});
});;