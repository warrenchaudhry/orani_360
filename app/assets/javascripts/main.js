//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require jquery_nested_form
//= require data-confirm-modal
//= require jquery.countdown

$(document).on("page:load ready", function(){
  $('#clock').countdown('2016/08/14 04:30:00')
    .on('update.countdown', function(event) {
      var $this = $(this).html(event.strftime(''
        + '<span>%-w</span> week%!w '
        + '<span>%-d</span> day%!d '
        + '<span>%H</span> hr '
        + '<span>%M</span> min '
        + '<span>%S</span> sec'));
    })
    .on('finish.countdown', function(event) {
      $(this).html('This offer has expired!')
      .parent().addClass('disabled');
    });
});
