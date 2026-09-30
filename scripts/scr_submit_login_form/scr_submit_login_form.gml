/// scr_submit_login_form()
function scr_submit_login_form() {
    with (obj_login) {
        if (is_loading) exit; // Prevent submitting while waiting on HTTP request
        
        if (mode == MODE_REGISTER) {
            // Validate Username length client-side first
            var _clean_user = string_trim(username_string);
            var _user_len = string_length(_clean_user);

            if (_user_len < 3 || _user_len > 20) {
                message_color = c_red;
                message_text = "Username must be between 3 and 20 characters.";
                exit;
            }

            // Call Supabase registration script
            var _res = scr_register_user(_clean_user, email_string, password_string);

            if (_res.success) {
                current_request_id = _res.async_id;
                is_loading = true;
                message_color = c_yellow;
                message_text = "Creating account...";
            } else {
                message_color = c_red;
                message_text = _res.message;
            }
        } 
        else if (mode == MODE_LOGIN) {
            // Call Supabase login script
            var _res = scr_login_user(email_string, password_string);

            if (_res.success) {
                current_request_id = _res.async_id;
                is_loading = true;
                message_color = c_yellow;
                message_text = "Authenticating...";
            } else {
                message_color = c_red;
                message_text = _res.message;
            }
        }
    }
}