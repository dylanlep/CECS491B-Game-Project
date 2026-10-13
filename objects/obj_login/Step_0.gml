/// obj_login - Step Event

draw_set_font(fnt_pixel);

var mx = mouse_x;
var my = mouse_y;

var toggle_text = (mode == MODE_LOGIN) ? "NO ACCOUNT? REGISTER" : "HAVE ACCOUNT? LOG IN";
var toggle_w    = string_width(toggle_text);
var toggle_x1   = room_width/2 - toggle_w/2;
var toggle_x2   = room_width/2 + toggle_w/2;
var toggle_hit_y1 = toggle_y - 6;
var toggle_hit_y2 = toggle_y + 6;

if (mouse_check_button_pressed(mb_left)) {

    var over_username = show_username && (mx >= username_box_x && mx <= username_box_x + field_width
                       && my >= username_box_y && my <= username_box_y + field_height);
    var over_email     = (mx >= email_box_x && mx <= email_box_x + field_width
                       && my >= email_box_y && my <= email_box_y + field_height);
    var over_password = (mx >= password_box_x && mx <= password_box_x + field_width
                       && my >= password_box_y && my <= password_box_y + field_height);
    var over_submit   = (mx >= submit_x1 && mx <= submit_x2 && my >= submit_y1 && my <= submit_y2);
    var over_toggle   = (mx >= toggle_x1 && mx <= toggle_x2 && my >= toggle_hit_y1 && my <= toggle_hit_y2);

    if (over_username) {
        active_field = FIELD_USERNAME;
        keyboard_string = username_string;
    } else if (over_email) {
        active_field = FIELD_EMAIL;
        keyboard_string = email_string;
    } else if (over_password) {
        active_field = FIELD_PASSWORD;
        keyboard_string = password_string;
    } else if (over_submit) {
        scr_submit_login_form();
    } else if (over_toggle) {
        mode = (mode == MODE_LOGIN) ? MODE_REGISTER : MODE_LOGIN;
        message_text = "";
        active_field = FIELD_NONE;
        scr_layout_login_fields();
    } else {
        active_field = FIELD_NONE;
    }
}

if (active_field == FIELD_USERNAME) {
    if (string_length(keyboard_string) > max_field_length) keyboard_string = string_copy(keyboard_string, 1, max_field_length);
    username_string = keyboard_string;
} else if (active_field == FIELD_EMAIL) {
    if (string_length(keyboard_string) > max_field_length) keyboard_string = string_copy(keyboard_string, 1, max_field_length);
    email_string = keyboard_string;
} else if (active_field == FIELD_PASSWORD) {
    if (string_length(keyboard_string) > max_field_length) keyboard_string = string_copy(keyboard_string, 1, max_field_length);
    password_string = keyboard_string;
}

if (keyboard_check_pressed(vk_tab)) {
    if (active_field == FIELD_USERNAME) {
        active_field = FIELD_EMAIL;
        keyboard_string = email_string;
    } else if (active_field == FIELD_EMAIL) {
        active_field = FIELD_PASSWORD;
        keyboard_string = password_string;
    } else {
        active_field = show_username ? FIELD_USERNAME : FIELD_EMAIL;
        keyboard_string = show_username ? username_string : email_string;
    }
}

if (keyboard_check_pressed(vk_enter)) {
    scr_submit_login_form();
}