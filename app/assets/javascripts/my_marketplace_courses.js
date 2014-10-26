$(document).ready(function() {
  $('#my_marketplace_created_course_setting_tabs a').click(function(e) {
    var tab_target = $(this).attr('data-target');
    console.log(tab_target);//fd
    switch_to_tab_head(tab_target);
    show_tab_content(tab_target);
  });
})

function switch_to_tab_head(id) {
  $('#my_marketplace_created_course_setting_tabs a').parent().removeClass('active');
  $('#my_marketplace_created_course_setting_tabs a[data-target="' + id + '"]').parent().addClass('active');
}

function show_tab_content(id) {
  $('.tab-content > .tab-pane').removeClass('active');
  $('.tab-content > .tab-pane[id="' + id + '"]').addClass('active');
}