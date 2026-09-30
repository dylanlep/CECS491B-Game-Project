var _request_id = async_load[? "id"];
var _result = async_load[? "result"];

if (_request_id != global.pending_auth_request_id) {
    exit;
}

var _data = json_decode(_result);

var _has_access_token = ds_map_exists(_data, "access_token");
var _has_user = ds_map_exists(_data, "user");

if (_has_access_token || _has_user) {

    if (_has_access_token) {
        global.supabase_access_token =
            ds_map_find_value(_data, "access_token");
    }

    if (global.pending_auth_mode == "login") {
        message_text = "Login successful!";
        ds_map_destroy(_data);
        room_goto(rm_lesson);
    } else {
        message_text = "Registration successful!";
        ds_map_destroy(_data);
    }

} else {
    message_text = "Authentication failed.";
    show_debug_message("Supabase authentication failed.");
    ds_map_destroy(_data);
}