/// obj_login - Step Event

var mx = mouse_x;
var my = mouse_y;

// --- Focus a field / hit a button on click ---
if (mouse_check_button_pressed(mb_left)) {

    var over_username = (mx >= username_box_x && mx <= username_box_x + field_width
                       && my >= username_box_y && my <= username_box_y + field_height);
    var over_password = (mx >= password_box_x && mx <= password_box_x + field_width
                       && my >= password_box_y && my <= password_box_y + field_height);

    if (over_username) {
        active_field = FIELD_USERNAME;
        keyboard_string = username_string;
    } else if (over_password) {
        active_field = FIELD_PASSWORD;
        keyboard_string = password_string;
    } else {
        var over_submit = (mx >= submit_x1 && mx <= submit_x2 && my >= submit_y1 && my <= submit_y2);

        if (over_submit) {
            scr_submit_login_form();
        } else {
            var toggle_y1 = submit_y2 + 30;
            var toggle_y2 = toggle_y1 + 30;

            if (my >= toggle_y1 && my <= toggle_y2) {
                mode = (mode == MODE_LOGIN) ? MODE_REGISTER : MODE_LOGIN;
                message_text = "";
            } else {
                active_field = FIELD_NONE;
            }
        }
    }
}

// --- Sync whichever field is focused with GameMaker's text buffer ---
// keyboard_string is a built-in global that behaves like a real text input
// (it already handles backspace for you). We copy it into whichever field
// is active, and swap it in/out when focus changes so each field keeps its
// own text.
if (active_field == FIELD_USERNAME) {
    if (string_length(keyboard_string) > max_field_length) {
        keyboard_string = string_copy(keyboard_string, 1, max_field_length);
    }
    username_string = keyboard_string;
} else if (active_field == FIELD_PASSWORD) {
    if (string_length(keyboard_string) > max_field_length) {
        keyboard_string = string_copy(keyboard_string, 1, max_field_length);
    }
    password_string = keyboard_string;
}

// --- Tab to switch fields, Enter to submit ---
if (keyboard_check_pressed(vk_tab)) {
    if (active_field == FIELD_USERNAME) {
        active_field = FIELD_PASSWORD;
        keyboard_string = password_string;
    } else {
        active_field = FIELD_USERNAME;
        keyboard_string = username_string;
    }
}

if (keyboard_check_pressed(vk_enter)) {
    scr_submit_login_form();
}