//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.en-GB.js
//= require jquery_nested_form
//= require data-confirm-modal

$(document).on("page:load ready", function(){
    $("input.datepicker").datepicker({
        format: 'yyyy-mm-dd',
        autoclose: true
    });
});
