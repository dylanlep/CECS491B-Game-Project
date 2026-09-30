var _request_id = async_load[? "id"];
var _result = async_load[? "result"];

if (_request_id != global.pending_auth_request_id) {
    exit;
}

var _data = json_decode(_result);

if (_data != -1 && ds_map_exists(_data, "access_token")) {
    global.supabase_access_token =
        ds_map_find_value(_data, "access_token");

    message_text = "Login successful!";
    ds_map_destroy(_data);

    room_goto(rm_lesson);
} else {
    message_text = "Authentication failed.";
    show_debug_message("Supabase response did not contain an access token.");

    if (_data != -1) {
        ds_map_destroy(_data);
    }
}