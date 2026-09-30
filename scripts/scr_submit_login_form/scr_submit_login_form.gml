// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_submit_login_form(){
	/// scr_submit_login_form
	/// Validates the form and stores the submitted strings for whoever
	/// wires up the actual server call.

	/// scr_submit_login_form
/// Validates the visible fields and stores them for the networking side.

	with (obj_login) {

	    if (mode == MODE_REGISTER) {
	        if (username_string == "" || email_string == "" || password_string == "") {
	            message_text = "Please fill in all fields.";
	            exit;
	        }
	        if (string_length(password_string) < 6) {
	            message_text = "Password must be at least 6 characters.";
	            exit;
	        }
	    } else {
	        if (email_string == "" || password_string == "") {
	            message_text = "Please fill in both fields.";
	            exit;
	        }
	    }

	    global.pending_username = username_string; // only meaningful in Register mode
	    global.pending_email    = email_string;
	    global.pending_password = password_string;
	    global.pending_mode     = (mode == MODE_LOGIN) ? "login" : "register";

	    show_debug_message("Form submitted -> mode: " + global.pending_mode
	        + ", email: " + global.pending_email);

	    // TODO (networking teammate): call scr_login_user(global.pending_email, global.pending_password)
	    // for login, or scr_register_user(global.pending_username, global.pending_email, global.pending_password)
	    // for register — both already exist on account_registration and return an async_id to
	    // match against the Async - HTTP event.

	    message_text = "Submitted,but not registered yet";
	}

}