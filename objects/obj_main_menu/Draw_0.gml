/// obj_main_menu - Draw

draw_set_font(fnt_pixel);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Title, drawn at double size
draw_set_color(c_aqua);
draw_text_transformed(room_width / 2, 60, title_text, 2, 2, 0);

// Buttons
for (var i = 0; i < array_length(buttons); i++) {
    var _y = btn_y0 + i * (btn_height + btn_spacing);
    ui_button_draw(btn_x, _y, btn_width, btn_height, buttons[i], i == selected);
}

// Message under the buttons
if (message_text != "") {
    draw_set_font(fnt_pixel);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_yellow);
    draw_text(room_width / 2, 200, message_text);
}

// Reset so other objects aren't affected
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);