/// obj_google_login_button - Draw

// Button
draw_set_color(c_white);
draw_rectangle(btn_x1, btn_y1, btn_x2, btn_y2, false);
draw_set_color(c_black);
draw_rectangle(btn_x1, btn_y1, btn_x2, btn_y2, true);

// Label
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text((btn_x1 + btn_x2) / 2, (btn_y1 + btn_y2) / 2, "Sign in with Google");

// Status / error message
if (message_text != "") {
    draw_set_color(c_red);
    draw_text(room_width / 2, btn_y2 + 30, message_text);
}

// Reset so other objects aren't affected
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);