function setSubmitButtonState() {
  $('#submit_search_btn').prop('disabled', $('#keywords').val() == '');
}
$(document).ready(function() {
  $('[data-toggle = "search-tooltip"]').tooltip();
  console.log($("#submit_search_btn").is('disabled'));
  console.log($('#keywords').val());
  setSubmitButtonState();
  $('#keywords').keyup(function() {
    setSubmitButtonState();
  })
});
