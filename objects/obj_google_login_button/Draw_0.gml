/// obj_google_login_button - Draw

draw_set_font(fnt_pixel);

// Button: same box sprite as the LOG IN button
draw_sprite_stretched(spr_ui_box, 0, btn_x1, btn_y1, btn_width, btn_height);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text((btn_x1 + btn_x2) / 2, (btn_y1 + btn_y2) / 2, "SIGN IN WITH GOOGLE");

// Message under the button
if (message_text != "") {
    draw_set_color(message_color);
    draw_text(room_width / 2, btn_y2 + 9, message_text);
}

// Reset so other objects aren't affected
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);