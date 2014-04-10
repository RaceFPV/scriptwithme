// This script allows bootstrap 3 popover functionality
$(function() {
	$('[data-toggle="popover-right"]').popover({'placement': 'right', html: 'true'});
	$('[data-toggle="popover-bottom"]').popover({trigger: 'click', 'placement': 'bottom', html: 'true'});
  $('[data-toggle="popover-top"]').popover({trigger: 'hover', 'placement': 'top'});
});

 $(function() {
    $('#datatable').dataTable( {
    	 "iDisplayLength": 15,
    	 "aLengthMenu": [[15, 25, 50, -1], [15, 25, 50, "All"]]
    });
  } );
 $(function() {
    $('#datatable1').dataTable( {
    	 "iDisplayLength": 15,
    	 "aLengthMenu": [[15, 25, 50, -1], [15, 25, 50, "All"]]
    });
  } );
 $(function() {
    $('#datatable2').dataTable( {
    	 "iDisplayLength": 15,
    	 "aLengthMenu": [[15, 25, 50, -1], [15, 25, 50, "All"]]
    });
  } );