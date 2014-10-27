$.getScript('published_markets.js');
$.getScript('purchase_history.js');
$(document).ready(function() {
  $('#my_marketplace_created_course_setting_tabs a').click(function(e) {
    var tab_target = $(this).attr('data-target');
    switch_to_tab_head(tab_target);
    show_tab_content(tab_target);
  });

});

function switch_to_tab_head(id) {
  $('#my_marketplace_created_course_setting_tabs a').parent().removeClass('active');
  $('#my_marketplace_created_course_setting_tabs a[data-target="' + id + '"]').parent().addClass('active');
}

function show_tab_content(id) {
  $('.tab-content > .tab-pane').removeClass('active');
  $('.tab-content > .tab-pane[id="' + id + '"]').addClass('active');
}

function prepareAjaxForm(selector, subject_i18n_key) {
  $(selector).submit(function(e) {
    var postData = $(this).serializeArray();
    var formUrl = $(this).attr('action');
    var subject_name = I18n.t(subject_i18n_key);
    $.ajax({
      url: formUrl,
      type: 'POST',
      data: postData,
      success: function(data, textStatus, jqXhr) {
        show_success_message(subject_name);
      },
      error: function(jqXhr, textStatus, errorThrown) {
        show_failure_message(subject_name);
      }
    });
    return false;
  })
}

// TODO better presentation of flashes

function show_success_message(subject_name) {
  $('<div>', {
    class: "alert alert-success",
    text: subject_name + I18n.t('Marketplace.my_marketplace_courses_settings.success_message')
  }).appendTo('#flash_area');
  alert(result_div);
}

function show_failure_message(subject_name) {
  var result_div = $('<div>', {
    class: "alert alert-error",
    text: subject_name + I18n.t('Marketplace.my_marketplace_courses_settings.failure_message')
  }).appendTo('#flash_area');
}
