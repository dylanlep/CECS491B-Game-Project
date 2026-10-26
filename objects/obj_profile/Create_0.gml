/// obj_profile - Create Event
// Profile screen (256x240 pixel UI) with a BACK button and an Edit Account popup.
// Account data lives in Supabase Auth: email, password, and username (user_metadata.username).

gpu_set_texfilter(false);
draw_set_font(fnt_pixel);

// ---------- Where BACK goes ----------
return_room = variable_global_exists("profile_return_room") ? global.profile_return_room : rm_mode_hub;

// ---------- Displayed account data (filled in by the Supabase GET) ----------
display_username = "";
display_email    = "";
display_created = "";

profile_message       = "";
profile_message_color = c_yellow;

// ---------- Request tracking ----------
profile_load_id  = -1;   // GET /auth/v1/user
save_request_id  = -1;   // PUT /auth/v1/user
busy             = false;
pending_email    = "";   // the email we asked to change to (if any)

// ---------- Main screen buttons ----------
edit_label = "EDIT ACCOUNT";
edit_w = ui_button_width(edit_label);
edit_h = 18;
edit_x = (room_width - edit_w) / 2;
edit_y = 188;

back_label = "BACK";
back_w = ui_button_width(back_label);
back_h = 16;
back_x = room_width  - back_w - 4;
back_y = room_height - back_h - 4;

hover_edit = false;
hover_back = false;

// ---------- Edit Account popup ----------
edit_open          = false;
edit_field         = 0;      // 0 = none, 1 = username, 2 = email, 3 = password
edit_username      = "";
edit_email         = "";
edit_password      = "";
edit_message       = "";
edit_message_color = c_yellow;

panel_x = 8;
panel_y = 4;
panel_w = room_width - 16;
panel_h = 232;

field_x = 20;
field_w = room_width - 40;   // 216
field_h = 18;
user_y  = 46;
email_y = 84;
pass_y  = 122;

popup_btn_y = 158;
popup_btn_h = 16;
save_w   = ui_button_width("SAVE");
cancel_w = ui_button_width("CANCEL");
popup_gap = 8;
save_x   = (room_width - (save_w + popup_gap + cancel_w)) / 2;
cancel_x = save_x + save_w + popup_gap;

msg_y = 182;

hover_save   = false;
hover_cancel = false;

// ---------- Helpers ----------

/// Shortens text to _n characters, ending in "..." if it was cut.
clip_text = function(_s, _n) {
    if (string_length(_s) <= _n) return _s;
    return string_copy(_s, 1, _n - 3) + "...";
};

/// Keeps the END of the text so the caret side stays visible while typing.
fit_text = function(_s) {
    var _max = floor((field_w - 8) / 8);   // 8 px per character in fnt_pixel
    if (string_length(_s) > _max) return string_copy(_s, string_length(_s) - _max + 1, _max);
    return _s;
};

/// Turns Supabase's "2026-10-20T12:34:56Z" into "OCT 20, 2026".
format_join_date = function(_iso) {
    if (!is_string(_iso) || string_length(_iso) < 10) return "";
    var _months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
    var _m = real(string_copy(_iso, 6, 2));
    if (_m < 1 || _m > 12) return "";
    return _months[_m - 1] + " " + string(real(string_copy(_iso, 9, 2))) + ", " + string_copy(_iso, 1, 4);
};

/// Copies a Supabase user object into the display variables.
apply_user = function(_d) {
    if (!is_struct(_d)) return;
    if (variable_struct_exists(_d, "id")) {
        global.user_id = _d.id;
    }
    if (variable_struct_exists(_d, "email")) {
        display_email = _d.email;
        global.email = _d.email;
    }
	if (variable_struct_exists(_d, "created_at")) {
        display_created = format_join_date(_d.created_at);
    }
    if (variable_struct_exists(_d, "user_metadata") && is_struct(_d.user_metadata)
    && variable_struct_exists(_d.user_metadata, "username")) {
        display_username = _d.user_metadata.username;
        global.username = _d.user_metadata.username;
    }
};

/// Validates the popup fields and sends only what changed to Supabase.
submit_edit = function() {
    if (busy) {
        edit_message = "Saving account changes...";
        edit_message_color = c_yellow;
        return;
    }

    edit_message_color = c_red;

    var _user  = string_trim(edit_username);
    var _email = string_trim(edit_email);
    var _pass  = edit_password;

    var _user_changed  = (_user  != display_username);
    var _email_changed = (_email != display_email);
    var _pass_changed  = (_pass  != "");

    if (!_user_changed && !_email_changed && !_pass_changed) {
        edit_message = "Nothing changed.";
        return;
    }

    // --- Username (same rules as registration) ---
    if (_user_changed) {
        if (string_length(_user) < 3 || string_length(_user) > 20) {
            edit_message = "Username must be 3-20 characters.";
            return;
        }
        if (string_pos(" ", _user) > 0) {
            edit_message = "Username cannot contain spaces.";
            return;
        }
    }

    // --- Email ---
    if (_email_changed) {
        var _at  = string_pos("@", _email);
        var _dot = string_last_pos(".", _email);
        if (string_pos(" ", _email) > 0) {
            edit_message = "Email cannot contain spaces.";
            return;
        }
        if (_at <= 1 || _dot <= _at + 1 || _dot == string_length(_email)) {
            edit_message = "Enter a valid email address.";
            return;
        }
    }

    // --- Password (same rules as registration) ---
    if (_pass_changed) {
        if (string_length(_pass) < 8) {
            edit_message = "Password must be at least 8 characters.";
            return;
        }
        var _has_num = false;
        var _has_special = false;
        var _special_chars = "!@#$%^&*()_+-=[]{}|;:'\",.<>/?\\~`";
        for (var i = 1; i <= string_length(_pass); i++) {
            var _c = string_char_at(_pass, i);
            var _o = ord(_c);
            if (_o >= 48 && _o <= 57) _has_num = true;
            if (string_pos(_c, _special_chars) > 0) _has_special = true;
        }
        if (!_has_num)     { edit_message = "Password needs a number."; return; }
        if (!_has_special) { edit_message = "Password needs a special character."; return; }
    }

    var _token = progress_token();
    if (_token == "") {
        edit_message = "Please log in again.";
        return;
    }

    // --- Build the body with ONLY the changed fields ---
    var _body = {};
    if (_email_changed) _body.email    = _email;
    if (_pass_changed)  _body.password = _pass;
    if (_user_changed)  _body.data     = { username: _user };   // stored as user_metadata.username

    var _h = progress_headers(_token);
    save_request_id = http_request(SUPABASE_URL + "/auth/v1/user", "PUT", _h, json_stringify(_body));
    ds_map_destroy(_h);

    if (save_request_id == -1) {
        edit_message = "Could not start the request.";
    } else {
        busy = true;
        pending_email = _email_changed ? _email : "";
        edit_message = "Saving account changes...";
        edit_message_color = c_yellow;
    }
};

// ---------- Load the logged-in user's details ----------
var _token = progress_token();
if (_token == "") {
    profile_message = "NOT LOGGED IN";
    profile_message_color = c_red;
} else {
    var _h = progress_headers(_token);
    profile_load_id = http_request(SUPABASE_URL + "/auth/v1/user", "GET", _h, "");
    ds_map_destroy(_h);
}

// ---------- Level / XP / coins / streak ----------
progress_init();
if (!global.progress_loaded) progress_load();   // normally already loaded by the mode hub
var _streak = scr_streak_get_data();
profile_streak = _streak.count;