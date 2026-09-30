function scr_submit_login_form() {
    with (obj_login) {

        if (mode == MODE_REGISTER) {
            if (username_string == "" || email_string == "" || password_string == "") {
                message_text = "Please fill in all fields.";
                exit;
            }

            if (string_length(password_string) < 8) {
                message_text = "Password must be at least 8 characters.";
                exit;
            }

        } else {
            if (email_string == "" || password_string == "") {
                message_text = "Please fill in both fields.";
                exit;
            }
        }

        var _response;

        if (mode == MODE_LOGIN) {
            _response = scr_login_user(email_string, password_string);
        } else {
            _response = scr_register_user(
                username_string,
                email_string,
                password_string
            );
        }

        if (!_response.success) {
            message_text = _response.message;
            exit;
        }

        global.pending_auth_request_id = _response.async_id;
        global.pending_auth_mode = (mode == MODE_LOGIN)
            ? "login"
            : "register";

        message_text = _response.message;

        show_debug_message(
            "Supabase request sent. Mode: "
            + global.pending_auth_mode
            + ", Request ID: "
            + string(global.pending_auth_request_id)
        );
    }
}