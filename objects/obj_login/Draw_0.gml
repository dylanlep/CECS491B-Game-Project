/// obj_login - Draw Event

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_color(c_white);
draw_text(room_width/2, 140, (mode == MODE_LOGIN) ? "Log In" : "Create Account");

// Username field
draw_set_color((active_field == FIELD_USERNAME) ? c_yellow : c_white);
draw_rectangle(username_box_x, username_box_y, username_box_x + field_width, username_box_y + field_height, true);
draw_set_halign(fa_left);
draw_text(username_box_x + 10, username_box_y + field_height/2,
    (username_string == "") ? "Username" : username_string);

// Password field (masked)
var masked = string_repeat("*", string_length(password_string));
draw_set_color((active_field == FIELD_PASSWORD) ? c_yellow : c_white);
draw_rectangle(password_box_x, password_box_y, password_box_x + field_width, password_box_y + field_height, true);
draw_text(password_box_x + 10, password_box_y + field_height/2,
    (password_string == "") ? "Password" : masked);

// Submit button
draw_set_halign(fa_center);
draw_set_color(c_green);
draw_rectangle(submit_x1, submit_y1, submit_x2, submit_y2, false);
draw_set_color(c_black);
draw_rectangle(submit_x1, submit_y1, submit_x2, submit_y2, true);
draw_set_color(c_white);
draw_text((submit_x1 + submit_x2) / 2, (submit_y1 + submit_y2) / 2,
    (mode == MODE_LOGIN) ? "Log In" : "Register");

// Toggle link
var toggle_y1 = submit_y2 + 30;
draw_set_color(c_aqua);
draw_text(room_width/2, toggle_y1 + 15,
    (mode == MODE_LOGIN) ? "Don't have an account? Register" : "Already have an account? Log in");

// Feedback message
if (message_text != "") {
    draw_set_color(c_red);
    draw_text(room_width/2, toggle_y1 + 60, message_text);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);