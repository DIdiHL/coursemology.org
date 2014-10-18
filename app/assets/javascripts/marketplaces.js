function setSubmitButtonState() {
  $('#submit_search_btn').prop('disabled', $('#keywords').val() == '');
}
$(document).ready(function() {
  $('[data-toggle = "search-tooltip"]').tooltip();
  setSubmitButtonState();
  $('#keywords').keyup(function() {
    setSubmitButtonState();
  })
});
