/// obj_login - Draw Event

draw_set_font(fnt_pixel);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_color(c_white);
draw_text(room_width/2, 40, (mode == MODE_LOGIN) ? "LOG IN" : "REGISTER");

if (show_username) {
    var user_box_spr = (active_field == FIELD_USERNAME) ? spr_ui_box_focus : spr_ui_box;
    draw_sprite_stretched(user_box_spr, 0, username_box_x, username_box_y, field_width, field_height);
    draw_set_halign(fa_left);
    draw_text(username_box_x + 4, username_box_y + field_height/2,
        (username_string == "") ? "NAME" : username_string);
}

var email_box_spr = (active_field == FIELD_EMAIL) ? spr_ui_box_focus : spr_ui_box;
draw_sprite_stretched(email_box_spr, 0, email_box_x, email_box_y, field_width, field_height);
draw_set_halign(fa_left);
draw_text(email_box_x + 4, email_box_y + field_height/2,
    (email_string == "") ? "EMAIL" : email_string);

var pass_box_spr = (active_field == FIELD_PASSWORD) ? spr_ui_box_focus : spr_ui_box;
draw_sprite_stretched(pass_box_spr, 0, password_box_x, password_box_y, field_width, field_height);
var masked = string_repeat("*", string_length(password_string));
draw_text(password_box_x + 4, password_box_y + field_height/2,
    (password_string == "") ? "PASS" : masked);

draw_set_halign(fa_center);
draw_sprite_stretched(spr_ui_box, 0, submit_x1, submit_y1, submit_width, submit_height);
draw_set_color(c_white);
draw_text((submit_x1 + submit_x2) / 2, (submit_y1 + submit_y2) / 2,
    (mode == MODE_LOGIN) ? "LOG IN" : "REGISTER");

draw_set_color(c_aqua);
draw_text(room_width/2, toggle_y,
    (mode == MODE_LOGIN) ? "NO ACCOUNT? REGISTER" : "HAVE ACCOUNT? LOG IN");

if (message_text != "") {
    draw_set_color(c_red);
    draw_text(room_width/2, feedback_y, message_text);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);