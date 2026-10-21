/// obj_mode_hub - Draw

// Title
draw_set_font(fnt_pixel);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_aqua);
draw_text(room_width / 2, 20, title_text);

// All buttons
for (var i = 0; i < array_length(btn_label); i++) {
    ui_button_draw(btn_x[i], btn_y[i], btn_w[i], btn_h, btn_label[i], i == selected);
}

// Message between the modes and the bottom row
if (message_text != "") {
    draw_set_font(fnt_pixel);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_yellow);
    draw_text(room_width / 2, 170, message_text);
}

// SCRUM-29: coin balance (top-right) and any save/load problem
draw_set_font(fnt_pixel);
draw_set_valign(fa_middle);
draw_set_halign(fa_right);
draw_set_color(c_yellow);
draw_text(room_width - 4, 6, (global.progress_load_id != -1) ? "LOADING..." : "COINS: " + string(global.coins));

if (global.progress_error != "" && message_text == "") {
    draw_set_halign(fa_center);
    draw_set_color(c_red);
    draw_text(room_width / 2, 170, global.progress_error);
}

// Reset so other objects aren't affected
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);