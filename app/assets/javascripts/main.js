//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require jquery_nested_form
//= require data-confirm-modal
//= require dataTables/jquery.dataTables
//= require dataTables/dataTables.bootstrap
//= require jquery.countdown
//= require nprogress
//= require nprogress-turbolinks

$(document).on("page:load ready", function(){
  $('#clock').countdown('2016/08/14 04:30:00')
    .on('update.countdown', function(event) {
      var $this = $(this).html(event.strftime(''
        + '<span>%-w</span> <small>week%!w</small> '
        + '<span>%-d</span> <small>day%!d</small> '
        + '<span>%H</span> <small>hr</small> '
        + '<span>%M</span> <small>min</small> '
        + '<span>%S</span> <small>sec</small>'));
    })
    .on('finish.countdown', function(event) {
      $(this).html('This offer has expired!')
      .parent().addClass('disabled');
    });
    
    $('*[data-toggle="lightbox"]').on('click', function(event) {
        event.preventDefault();
        $(this).ekkoLightbox();
    });

    $('.table-listing').dataTable();

    NProgress.configure({
      showSpinner: false,
      ease: 'ease',
      speed: 500
    });
});
