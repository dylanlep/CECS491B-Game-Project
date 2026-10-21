/// obj_profile - Async HTTP

progress_handle_async();   // coins / XP load (ignores IDs that aren't its own)

var _id = async_load[? "id"];
if (_id != profile_load_id && _id != save_request_id) exit;   // not ours
if (async_load[? "status"] == 1) exit;                         // still downloading

var _status = async_load[? "status"];
var _http   = async_load[? "http_status"];
var _ok     = (_status == 0) && _http >= 200 && _http < 300;

var _data = undefined;
try { _data = json_parse(async_load[? "result"]); } catch (_e) { _data = undefined; }

// ---------- Result of the profile load ----------
if (_id == profile_load_id) {
    profile_load_id = -1;
    if (_ok) {
        apply_user(_data);
    } else if (_status == 0 && (_http == 401 || _http == 403)) {
        profile_message = "SESSION EXPIRED. LOG IN AGAIN.";
        profile_message_color = c_red;
    } else {
        profile_message = "COULD NOT LOAD PROFILE";
        profile_message_color = c_red;
    }
    exit;
}

// ---------- Result of the save ----------
save_request_id = -1;
busy = false;

if (_ok) {
    apply_user(_data);
    edit_open     = false;
    edit_field    = 0;
    edit_password = "";

    // If email confirmation is on, Supabase keeps the OLD email until the link is clicked.
    if (pending_email != "" && pending_email != display_email) {
        profile_message = "CHECK EMAIL TO CONFIRM CHANGE";
    } else {
        profile_message = "ACCOUNT UPDATED!";
    }
    profile_message_color = c_lime;
} else {
    edit_message_color = c_red;
    if (_status < 0) {
        edit_message = "Could not connect to the server.";
    } else if (_http == 401 || _http == 403) {
        edit_message = "Session expired. Please log in again.";
    } else if (is_struct(_data) && variable_struct_exists(_data, "msg")) {
        edit_message = _data.msg;
    } else if (is_struct(_data) && variable_struct_exists(_data, "message")) {
        edit_message = _data.message;
    } else {
        edit_message = "Could not save changes (HTTP " + string(_http) + ").";
    }
}
pending_email = "";