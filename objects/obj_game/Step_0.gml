/// obj_game - Step Event

if (account_open) {
    if (mouse_check_button_pressed(mb_left)) {
        var over_email = mouse_x >= 38 && mouse_x <= room_width - 12
            && mouse_y >= 70 && mouse_y <= 92;
        var over_password = mouse_x >= 38 && mouse_x <= room_width - 12
            && mouse_y >= 108 && mouse_y <= 130;
        var over_save = mouse_x >= room_width/2 - 36 && mouse_x <= room_width/2 + 36
            && mouse_y >= 150 && mouse_y <= 170;
        var over_back = mouse_x >= room_width/2 - 30 && mouse_x <= room_width/2 + 30
            && mouse_y >= 178 && mouse_y <= 198;

        if (over_email) {
            account_active_field = 1;
            keyboard_string = account_email_input;
        } else if (over_password) {
            account_active_field = 2;
            keyboard_string = account_password_input;
        } else if (over_save) {
            var _new_email = string_trim(account_email_input);

            if (account_busy) {
                account_message = "Saving account changes...";
            } else if (_new_email == "" && account_password_input == "") {
                account_message = "Enter a new email or password.";
            } else if (_new_email != "" && string_pos(" ", _new_email) > 0) {
                account_message = "Email cannot contain spaces.";
            } else if (_new_email != "" && (string_pos("@", _new_email) <= 1
                || string_last_pos(".", _new_email) <= string_pos("@", _new_email) + 1
                || string_last_pos(".", _new_email) == string_length(_new_email))) {
                account_message = "Enter a valid email address.";
            } else if (account_password_input != "" && string_length(account_password_input) < 8) {
                account_message = "Password must be at least 8 characters.";
            } else {
                var _pw_has_number = false;
                var _pw_has_special = false;
                var _special_chars = "!@#$%^&*()_+-=[]{}|;:'\",.<>/?\\~`";

                for (var _p = 1; _p <= string_length(account_password_input); _p++) {
                    var _char = string_char_at(account_password_input, _p);
                    var _ord = ord(_char);
                    if (_ord >= 48 && _ord <= 57) _pw_has_number = true;
                    if (string_pos(_char, _special_chars) > 0) _pw_has_special = true;
                }

                if (account_password_input != "" && !_pw_has_number) {
                    account_message = "Password needs a number.";
                } else if (account_password_input != "" && !_pw_has_special) {
                    account_message = "Password needs a special character.";
                } else if (!variable_global_exists("supabase_access_token")
                    || global.supabase_access_token == "") {
                    account_message = "Please log in again.";
                } else {
                    var _profile_url = "https://pwodiopbnnngkfwqpjrg.supabase.co/auth/v1/user";
                    var _profile_body = ds_map_create();
                    if (_new_email != "") ds_map_add(_profile_body, "email", _new_email);
                    if (account_password_input != "") ds_map_add(_profile_body, "password", account_password_input);
                    var _profile_json = json_encode(_profile_body);
                    ds_map_destroy(_profile_body);

                    var _profile_headers = ds_map_create();
                    ds_map_add(_profile_headers, "Content-Type", "application/json");
                    ds_map_add(_profile_headers, "apikey", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB3b2Rpb3Bibm5uZ2tmd3FwanJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTAxNzc0MTQsImV4cCI6MjEwNTc1MzQxNH0.jIDwM76MXF36zZG8S2T79Pu4B9fCG_LeaXfsA9W7pXQ");
                    ds_map_add(_profile_headers, "Authorization", "Bearer " + global.supabase_access_token);
                    account_request_id = http_request(_profile_url, "PUT", _profile_headers, _profile_json);
                    ds_map_destroy(_profile_headers);

                    if (account_request_id == -1) {
                        account_message = "Could not start the request.";
                    } else {
                        account_busy = true;
                        account_pending_email_change = (_new_email != "");
                        account_message = "Saving account changes...";
                    }
                }
            }
        } else if (over_back) {
            account_open = false;
            account_active_field = 0;
            account_email_input = "";
            account_password_input = "";
            account_message = "";
        } else {
            account_active_field = 0;
        }
    }

    if (account_active_field == 1) {
        if (string_length(keyboard_string) > 64) keyboard_string = string_copy(keyboard_string, 1, 64);
        account_email_input = keyboard_string;
    } else if (account_active_field == 2) {
        if (string_length(keyboard_string) > 128) keyboard_string = string_copy(keyboard_string, 1, 128);
        account_password_input = keyboard_string;
    }

    if (keyboard_check_pressed(vk_tab)) {
        account_active_field = (account_active_field == 1) ? 2 : 1;
        keyboard_string = (account_active_field == 1) ? account_email_input : account_password_input;
    }
    exit;
}

if (mouse_check_button_pressed(mb_left)
&& mouse_x >= 4 && mouse_x <= 48 && mouse_y >= 22 && mouse_y <= 36) {
    account_open = true;
    account_active_field = 0;
    account_email_input = "";
    account_password_input = "";
    account_message = "";
    account_busy = false;
    account_pending_email_change = false;
    exit;
}

if (feedback_timer > 0) {
    feedback_timer -= 1;
    if (feedback_timer <= 0) feedback_text = "";
}

if (mouse_check_button_pressed(mb_left)) {

    // --- Language tabs ---
    for (var i = 0; i < lesson_count; i++) {
        var bx1 = lang_button_x[i];
        var by1 = lang_button_y;
        var bx2 = bx1 + lang_button_width;
        var by2 = by1 + lang_button_height;

        if (mouse_x >= bx1 && mouse_x <= bx2 && mouse_y >= by1 && mouse_y <= by2) {
            current_lesson = i;
            scr_setup_lesson();
        }
    }

    // --- Check button ---
	if (mouse_x >= check_btn_x1 && mouse_x <= check_btn_x2
	&& mouse_y >= check_btn_y1 && mouse_y <= check_btn_y2) {

	    var all_filled  = true;
	    var all_correct = true;

	    for (var i = 0; i < word_count; i++) {
	        if (slot_occupant[i] == noone) {
	            all_filled = false;
	        } else if (slot_occupant[i].correct_index != i) {
	            all_correct = false;
	        }
	    }

	    if (!all_filled) {
	        feedback_text  = "Fill in all blocks!";
	        feedback_timer = 90;

	    } else if (all_correct) {
	        var xp_earned = max(min_xp, base_xp - (mistake_count * mistake_penalty));
	        language_scores[current_lesson] += xp_earned;

	        scr_setup_lesson(); // new shuffled round — also resets mistake_count + feedback

	        // Set AFTER scr_setup_lesson, since that script blanks feedback_text/timer
	        feedback_text  = "Correct! +" + string(xp_earned) + " XP";
	        feedback_timer = 90;

	    } else {
	        mistake_count += 1;
	        feedback_text  = "Try again.";
	        feedback_timer = 90;
	    }
	}
}
