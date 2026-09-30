/// scr_logout
/// Logs the player out: ends the session on Supabase, then clears it locally.

// Supabase's PUBLIC key. It's designed to be inside game code (unlike the
// Google Client Secret). Same key Emmanuel uses on em_branch.
#macro SUPABASE_PUBLISHABLE_KEY "sb_publishable_hri5mZ3bBR-n9bHt8wC_dQ_HRE5CaEU"
#macro LOGOUT_TIMEOUT_SECONDS 3

/// Returns the saved token, or "" if nobody is logged in.
function logout_get_token() {
    if (variable_global_exists("access_token") && is_string(global.access_token)) {
        return global.access_token;
    }
    return "";
}

/// Asks Supabase to end this player's session.
/// Returns the request id to watch for in the Async HTTP event,
/// or -1 if there's no token (nothing to end on the server).
function logout_send_request() {
    var _token = logout_get_token();
    if (_token == "") return -1;

    var _headers = ds_map_create();
    ds_map_add(_headers, "apikey", SUPABASE_PUBLISHABLE_KEY);
    ds_map_add(_headers, "Authorization", "Bearer " + _token);

    // scope=local ends only THIS session, not the player's sessions on other devices.
    var _request_id = http_request(SUPABASE_URL + "/auth/v1/logout?scope=local", "POST", _headers, "");
    ds_map_destroy(_headers);
    return _request_id;
}

/// Erases everything the game remembers about the logged-in player.
function logout_clear_local_session() {
    global.access_token  = "";
    global.refresh_token = "";
    global.user_id       = "";
    global.auth_token    = "";   // older name used on em_branch; harmless to clear
}

/// Final step: clear the session, leave a message for the login screen, go there.
function logout_finish(_message) {
    logout_clear_local_session();
    global.login_screen_message = _message;
    room_goto(rm_login);
}