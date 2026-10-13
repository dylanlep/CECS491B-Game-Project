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
var forgot_text = "FORGOT PASSWORD?";
var forgot_x1 = room_width/2 - string_width(forgot_text)/2;
var forgot_x2 = room_width/2 + string_width(forgot_text)/2;
var forgot_y = submit_y2 + 8;

if (mouse_check_button_pressed(mb_left)) {

    var over_username = show_username && (mx >= username_box_x && mx <= username_box_x + field_width
                       && my >= username_box_y && my <= username_box_y + field_height);
    var over_email     = (mx >= email_box_x && mx <= email_box_x + field_width
                       && my >= email_box_y && my <= email_box_y + field_height);
    var over_password = (mx >= password_box_x && mx <= password_box_x + field_width
                       && my >= password_box_y && my <= password_box_y + field_height);
    var over_submit   = (mx >= submit_x1 && mx <= submit_x2 && my >= submit_y1 && my <= submit_y2);
    var over_toggle   = (mx >= toggle_x1 && mx <= toggle_x2 && my >= toggle_hit_y1 && my <= toggle_hit_y2);
    var over_forgot   = mode == MODE_LOGIN && mx >= forgot_x1 && mx <= forgot_x2
                       && my >= forgot_y - 6 && my <= forgot_y + 6;

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
    } else if (over_forgot) {
        if (string_trim(email_string) == "") {
            message_text = "Enter your email first.";
        } else {
            var _email = string_trim(email_string);
            var _at_pos = string_pos("@", _email);
            var _dot_pos = string_last_pos(".", _email);
            if (_at_pos <= 1 || _dot_pos <= _at_pos + 1 || _dot_pos == string_length(_email)) {
                message_text = "Enter a valid email address.";
            } else {
                var _recover_redirect = "https://tourmaline-melba-f456c3.netlify.app/reset-password.html";
                var _recover_url = "https://pwodiopbnnngkfwqpjrg.supabase.co/auth/v1/recover?redirect_to="
                    + _recover_redirect;
                var _recover_body = ds_map_create();
                ds_map_add(_recover_body, "email", _email);
                var _recover_json = json_encode(_recover_body);
                ds_map_destroy(_recover_body);
                var _recover_headers = ds_map_create();
                ds_map_add(_recover_headers, "Content-Type", "application/json");
                ds_map_add(_recover_headers, "apikey", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB3b2Rpb3Bibm5uZ2tmd3FwanJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTAxNzc0MTQsImV4cCI6MjEwNTc1MzQxNH0.jIDwM76MXF36zZG8S2T79Pu4B9fCG_LeaXfsA9W7pXQ");
                global.pending_auth_request_id = http_request(_recover_url, "POST", _recover_headers, _recover_json);
                ds_map_destroy(_recover_headers);
                global.pending_auth_mode = "recover";
                message_text = "Sending reset email...";
            }
        }
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
