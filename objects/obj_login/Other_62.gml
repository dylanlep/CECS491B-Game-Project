/// obj_login - Async HTTP Event 

var _request_id = async_load[? "id"];

if (_request_id != global.pending_auth_request_id) {
    exit;
}

var _request_status = async_load[? "status"];
if (_request_status == 1) exit; // Request is still downloading.

if (_request_status < 0) {
    message_text = "Could not connect to the authentication service.";
    is_loading = false;
    global.pending_auth_request_id = -1;
    exit;
}

var _http_status = async_load[? "http_status"];
var _result = async_load[? "result"];
var _data = json_decode(_result);

// Handle Password Recovery Mode
if (global.pending_auth_mode == "recover") {
    if (_http_status >= 200 && _http_status < 300) {
        message_text = "If the account exists, a reset email was sent.";
    } else if (ds_map_exists(_data, "msg")) {
        message_text = ds_map_find_value(_data, "msg");
    } else if (ds_map_exists(_data, "message")) {
        message_text = ds_map_find_value(_data, "message");
    } else {
        message_text = "Could not send reset email (HTTP " + string(_http_status) + ").";
    }
    ds_map_destroy(_data);
    
    is_loading = false;
    global.pending_auth_request_id = -1;
    exit;
}

var _has_access_token = ds_map_exists(_data, "access_token");
var _has_user = ds_map_exists(_data, "user");

if (_has_access_token || _has_user) {

    // Save Access Token
    if (_has_access_token) {
        global.supabase_access_token = ds_map_find_value(_data, "access_token");
    }

    // Extract User Details (Email and Username from metadata)
    if (_has_user) {
        var _user_map = ds_map_find_value(_data, "user");
        
        // Extract email
        if (ds_map_exists(_user_map, "email")) {
            global.user_email = ds_map_find_value(_user_map, "email");
        }
        
        // Extract username from user_metadata
        if (ds_map_exists(_user_map, "user_metadata")) {
            var _meta_map = ds_map_find_value(_user_map, "user_metadata");
            if (ds_map_exists(_meta_map, "username")) {
                global.username = ds_map_find_value(_meta_map, "username");
            }
        }
    }
    
    // Safety Fallbacks
    if (!variable_global_exists("username") || global.username == "") {
        global.username = "Player";
    }
    if (!variable_global_exists("user_email") || global.user_email == "") {
        global.user_email = "Unknown";
    }

    if (global.pending_auth_mode == "login") {
        message_text = "Login successful!";
        ds_map_destroy(_data);
        room_goto(rm_mode_hub); 
    } else {
        message_text = "Registration successful!";
        ds_map_destroy(_data);
        is_loading = false;
        global.pending_auth_request_id = -1;
    }

} else {
    // Handle Authentication / Login Errors
    if (ds_map_exists(_data, "msg")) {
        message_text = ds_map_find_value(_data, "msg");
    } else if (ds_map_exists(_data, "message")) {
        message_text = ds_map_find_value(_data, "message");
    } else {
        message_text = "Authentication failed (HTTP " + string(_http_status) + ").";
    }
    
    show_debug_message("Supabase authentication failed.");
    ds_map_destroy(_data);
    
    // Unlock UI so the user can try again
    is_loading = false;
    global.pending_auth_request_id = -1;
}