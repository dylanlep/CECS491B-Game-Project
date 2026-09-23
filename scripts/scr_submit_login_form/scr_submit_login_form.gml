// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_submit_login_form(){
	/// scr_submit_login_form
	/// Validates the form and stores the submitted strings for whoever
	/// wires up the actual server call.

	with (obj_login) {

	    if (username_string == "" || password_string == "") {
	        message_text = "Please fill in both fields.";
	        exit;
	    }

	    if (mode == MODE_REGISTER && string_length(password_string) < 6) {
	        message_text = "Password must be at least 6 characters.";
	        exit;
	    }

	    // Store what was entered so any other object (or a networking script)
	    // can read it. global.* is visible from anywhere in the project.
	    global.pending_username = username_string;
	    global.pending_password = password_string;
	    global.pending_mode     = (mode == MODE_LOGIN) ? "login" : "register";

	    show_debug_message("Form submitted -> mode: " + global.pending_mode
	        + ", username: " + global.pending_username);

	    // TODO (networking teammate): replace this debug message with a real
	    // http_request() call to your backend's /login or /register endpoint,
	    // sending global.pending_username / global.pending_password. Handle
	    // the async "HTTP" event on whatever object makes the request to read
	    // the server's response.

	    message_text = "Submitted! (not yet connected to a server)";
	}

}