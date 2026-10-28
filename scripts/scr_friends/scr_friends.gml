/// scr_friends - SCRUM-38 (add / accept friends) + SCRUM-39 (remove friends)
///
/// All friend changes happen on the SERVER (Supabase functions in
/// supabase/scrum38_39_friends.sql). The game only asks and shows answers.
///
/// How a friends screen uses this script:
///   Create event:        friends_load();
///   Async - HTTP event:  friends_handle_async();
///   Draw:                global.friends            [{ id, name, xp }]  (Dylan L's shape)
///                        global.friend_requests_in [{ id, name }]      waiting for MY answer
///                        global.friend_requests_out[{ id, name }]      I sent
///                        global.friends_message    text to show the player
///   Buttons:             friends_send(username), friends_accept(id),
///                        friends_decline(id), friends_remove(id)

/// Creates the friends variables once.
function friends_init() {
    if (variable_global_exists("friends_ready")) return;
    global.friends_ready       = true;
    global.friends             = [];
    global.friend_requests_in  = [];
    global.friend_requests_out = [];
    global.friends_loaded      = false;
    global.friends_message     = "";
    global.friends_my_name     = "";
    global.friends_token       = "";   // whose list this is (so a new login never sees the old list)
    global.friends_sync_id     = -1;
    global.friends_load_id     = -1;
    global.friends_action_id   = -1;
    global.friends_action      = "";   // "send", "accept", "decline", "remove"
    global.friends_action_name = "";   // username typed for "send"
}

/// Calls a Supabase server function with a JSON body (text). Returns the request id, or -1.
function friends_rpc(_function, _body) {
    var _token = progress_token();
    if (_token == "") return -1;
    var _h  = progress_headers(_token);
    var _id = http_request(SUPABASE_URL + "/rest/v1/rpc/" + _function, "POST", _h, _body);
    ds_map_destroy(_h);
    return _id;
}

/// Is the player waiting on an answer from the server?
function friends_busy() {
    friends_init();
    return (global.friends_sync_id != -1 || global.friends_load_id != -1 || global.friends_action_id != -1);
}

/// Call when the friends screen opens: saves my username for search, then loads my lists.
function friends_load() {
    friends_init();
    var _token = progress_token();
    if (_token == "") { global.friends_message = "PLEASE LOG IN FIRST"; return; }

    // A different player logged in? Forget the previous player's lists.
    if (_token != global.friends_token) {
        global.friends             = [];
        global.friend_requests_in  = [];
        global.friend_requests_out = [];
        global.friends_loaded      = false;
        global.friends_token       = _token;
    }
    if (global.friends_sync_id != -1 || global.friends_load_id != -1) return;   // already loading
    global.friends_message = "LOADING...";
    global.friends_sync_id = friends_rpc("friends_sync_profile", "{}");
    if (global.friends_sync_id == -1) global.friends_message = "COULD NOT REACH SERVER";
}

/// Re-reads the lists (after an action). No username sync needed.
function friends_reload() {
    friends_init();
    if (global.friends_load_id != -1) return;
    global.friends_load_id = friends_rpc("get_friends", "{}");
}

/// SCRUM-38: send a friend request by username.
function friends_send(_username) {
    friends_init();
    var _name = string_trim(_username);
    if (_name == "")   { global.friends_message = "TYPE A USERNAME FIRST"; return; }
    if (friends_busy()) { global.friends_message = "PLEASE WAIT...";       return; }
    global.friends_action      = "send";
    global.friends_action_name = _name;
    global.friends_message     = "SENDING...";
    global.friends_action_id   = friends_rpc("send_friend_request", json_stringify({ p_username: _name }));
    if (global.friends_action_id == -1) global.friends_message = "COULD NOT REACH SERVER";
}

/// SCRUM-38: answer a request someone sent me.
function friends_accept(_id)  { friends_respond(_id, true);  }
function friends_decline(_id) { friends_respond(_id, false); }

function friends_respond(_id, _accept) {
    friends_init();
    if (friends_busy()) { global.friends_message = "PLEASE WAIT..."; return; }
    global.friends_action    = _accept ? "accept" : "decline";
    global.friends_message   = "PLEASE WAIT...";
    // body written by hand so true/false are real JSON booleans on every platform
    var _body = "{\"p_id\":" + string(_id) + ",\"p_accept\":" + (_accept ? "true" : "false") + "}";
    global.friends_action_id = friends_rpc("respond_friend_request", _body);
    if (global.friends_action_id == -1) global.friends_message = "COULD NOT REACH SERVER";
}

/// SCRUM-39: remove a friend (or cancel a request I sent).
function friends_remove(_id) {
    friends_init();
    if (friends_busy()) { global.friends_message = "PLEASE WAIT..."; return; }
    global.friends_action    = "remove";
    global.friends_message   = "REMOVING...";
    global.friends_action_id = friends_rpc("remove_friend", "{\"p_id\":" + string(_id) + "}");
    if (global.friends_action_id == -1) global.friends_message = "COULD NOT REACH SERVER";
}

/// Forget everything (e.g. on logout). Safe to call any time.
function friends_clear() {
    friends_init();
    global.friends             = [];
    global.friend_requests_in  = [];
    global.friend_requests_out = [];
    global.friends_loaded      = false;
    global.friends_message     = "";
    global.friends_token       = "";
}

/// Put this in the Async - HTTP event of any object that uses friends.
function friends_handle_async() {
    friends_init();
    var _id      = async_load[? "id"];
    var _is_sync = (_id == global.friends_sync_id);
    var _is_load = (_id == global.friends_load_id);
    var _is_act  = (_id == global.friends_action_id);
    if (!_is_sync && !_is_load && !_is_act) return;   // not ours
    if (async_load[? "status"] == 1) return;           // still downloading

    if (_is_sync) global.friends_sync_id   = -1;
    if (_is_load) global.friends_load_id   = -1;
    if (_is_act)  global.friends_action_id = -1;

    var _http = async_load[? "http_status"];
    var _ok   = async_load[? "status"] == 0 && _http >= 200 && _http < 300;
    var _data = undefined;
    try { _data = json_parse(async_load[? "result"]); } catch (_e) { _data = undefined; }

    if (!_ok || !is_struct(_data)) {
        global.friends_message = "SERVER ERROR (" + string(_http) + ")";
        show_debug_message("Friends request failed: HTTP " + string(_http) + " " + string(async_load[? "result"]));
        return;
    }

    // --- 1) username saved -> now load the lists ---
    if (_is_sync) {
        if (variable_struct_exists(_data, "username")) global.friends_my_name = _data.username;
        global.friends_message = "";
        if (variable_struct_exists(_data, "status") && _data.status == "taken") {
            global.friends_message = "USERNAME " + string_upper(global.friends_my_name) + " IS TAKEN - CHANGE IT IN PROFILE";
        }
        friends_reload();
        return;
    }

    // --- 2) the lists arrived ---
    if (_is_load) {
        global.friends             = variable_struct_exists(_data, "friends")  ? _data.friends  : [];
        global.friend_requests_in  = variable_struct_exists(_data, "incoming") ? _data.incoming : [];
        global.friend_requests_out = variable_struct_exists(_data, "outgoing") ? _data.outgoing : [];
        global.friends_loaded      = true;
        if (global.friends_message == "LOADING...") global.friends_message = "";
        return;
    }

    // --- 3) an action finished -> show the answer, then refresh the lists ---
    var _status = variable_struct_exists(_data, "status") ? _data.status : "";
    var _who    = string_upper(global.friends_action_name);
    switch (_status) {
        case "sent":            global.friends_message = "REQUEST SENT TO " + _who;     break;
        case "accepted":        global.friends_message = "YOU ARE NOW FRIENDS!";         break;
        case "declined":        global.friends_message = "REQUEST DECLINED";             break;
        case "removed":         global.friends_message = (global.friends_action == "remove") ? "REMOVED" : "DONE"; break;
        case "self":            global.friends_message = "THAT'S YOU!";                  break;
        case "already_friends": global.friends_message = "ALREADY FRIENDS WITH " + _who; break;
        case "already_sent":    global.friends_message = "REQUEST ALREADY SENT";         break;
        case "not_found":
            global.friends_message = (global.friends_action == "send")
                ? "NO PLAYER NAMED " + _who
                : "ALREADY HANDLED";
            break;
        default:                global.friends_message = "SOMETHING WENT WRONG";         break;
    }
    friends_reload();
}