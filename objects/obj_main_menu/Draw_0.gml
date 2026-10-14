/// obj_main_menu - Draw

draw_set_font(fnt_pixel);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_color(c_aqua);
draw_text_transformed(room_width / 2, 48, title_text, 2, 2, 0);

for (var i = 0; i < array_length(menu_buttons); i++) {
    var _button_y = button_y_start + i * (button_height + button_gap);
    draw_sprite_stretched(selected_button == i ? spr_ui_box_focus : spr_ui_box,
        0, button_x, _button_y, button_width, button_height);
    draw_set_color(selected_button == i ? c_yellow : c_white);
    draw_text(button_x + button_width / 2, _button_y + button_height / 2,
        menu_buttons[i]);
}

// Daily streak panel
var _panel_x = room_width / 2 - 82;
var _panel_y = 157;
var _panel_w = 164;
var _panel_h = 62;
draw_sprite_stretched(spr_ui_box, 0, _panel_x, _panel_y, _panel_w, _panel_h);
draw_set_color(c_aqua);
draw_text(room_width / 2, _panel_y + 10, "DAILY STREAK");
draw_set_color(c_yellow);
var _day_label = streak_count == 1 ? "DAY" : "DAYS";
draw_text(room_width / 2, _panel_y + 27,
    string(streak_count) + " " + _day_label);
draw_set_color(c_white);
draw_text(room_width / 2, _panel_y + 45,
    streak_completed_today ? "TODAY: DONE" : "PLAY TODAY");

if (message_text != "") {
    draw_set_color(c_yellow);
    draw_text(room_width / 2, 232, message_text);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
