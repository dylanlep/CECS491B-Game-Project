/// scr_player_progress
/// SCRUM-29: saves each player's coins and owned shop items in Supabase
/// (table: player_progress). ALL coin changes go through these functions,
/// so switching to server-side functions later only changes this file.

/// Makes sure every global this script uses exists.
function progress_init() {
    if (!variable_global_exists("coins"))            global.coins = 0;
    if (!variable_global_exists("shop_owned"))       global.shop_owned = {};
    if (!variable_global_exists("progress_loaded"))  global.progress_loaded = false;
    if (!variable_global_exists("progress_load_id")) global.progress_load_id = -1;
    if (!variable_global_exists("progress_save_id")) global.progress_save_id = -1;
    if (!variable_global_exists("progress_error"))   global.progress_error = "";
}

/// The logged-in player's token, or "" if nobody is logged in.
function progress_token() {
    if (variable_global_exists("supabase_access_token") && is_string(global.supabase_access_token)) {
        return global.supabase_access_token;
    }
    return "";
}

/// Headers every Supabase request needs.
function progress_headers(_token) {
    var _h = ds_map_create();
    ds_map_add(_h, "apikey", SUPABASE_PUBLISHABLE_KEY);
    ds_map_add(_h, "Authorization", "Bearer " + _token);
    ds_map_add(_h, "Content-Type", "application/json");
    return _h;
}

/// Ask Supabase for this player's coins and owned items.
function progress_load() {
    progress_init();
    var _token = progress_token();
    if (_token == "" || global.progress_load_id != -1) return;   // not logged in, or already loading

    var _h = progress_headers(_token);
    global.progress_load_id = http_request(
        SUPABASE_URL + "/rest/v1/player_progress?select=coins,owned", "GET", _h, "");
    ds_map_destroy(_h);
}

/// Send the current coins and owned items to Supabase (creates the row the first time).
function progress_save() {
    progress_init();
    var _token = progress_token();
    if (_token == "" || !global.progress_loaded) return;   // never overwrite data we haven't loaded

    var _body = json_stringify({
        coins: global.coins,
        owned: variable_struct_get_names(global.shop_owned)
    });
    var _h = progress_headers(_token);
    ds_map_add(_h, "Prefer", "resolution=merge-duplicates,return=minimal");
    global.progress_save_id = http_request(
        SUPABASE_URL + "/rest/v1/player_progress?on_conflict=user_id", "POST", _h, _body);
    ds_map_destroy(_h);
}

/// Try to buy an item. Returns "bought", "owned" or "poor".
function progress_buy(_name, _price) {
    progress_init();
    if (variable_struct_exists(global.shop_owned, _name)) return "owned";
    if (global.coins < _price) return "poor";

    global.coins -= _price;
    variable_struct_set(global.shop_owned, _name, true);
    progress_save();
    return "bought";
}

/// Add coins the player earned (XP from a lesson).
function progress_earn(_amount) {
    progress_init();
    if (_amount <= 0) return;
    global.coins += _amount;
    progress_save();
}

/// Forget this player's progress on this device (logout). Supabase keeps it.
function progress_clear() {
    global.coins            = 0;
    global.shop_owned       = {};
    global.progress_loaded  = false;
    global.progress_load_id = -1;
    global.progress_save_id = -1;
    global.progress_error   = "";
}

/// Call this from the Async - HTTP event of any object on screen.
function progress_handle_async() {
    progress_init();
    var _id = async_load[? "id"];
    if (_id != global.progress_load_id && _id != global.progress_save_id) return;   // not ours
    if (async_load[? "status"] == 1) return;                                        // still downloading

    var _http = async_load[? "http_status"];
    var _ok   = async_load[? "status"] == 0 && _http >= 200 && _http < 300;

    if (_id == global.progress_load_id) {
        global.progress_load_id = -1;
        if (!_ok) { global.progress_error = "COULD NOT LOAD PROGRESS"; return; }

        var _rows = [];
        try { _rows = json_parse(async_load[? "result"]); } catch (_e) { _rows = []; }

        global.coins      = 0;
        global.shop_owned = {};
        if (is_array(_rows) && array_length(_rows) > 0) {        // returning player
            global.coins = _rows[0].coins;
            var _owned = _rows[0].owned;
            for (var i = 0; i < array_length(_owned); i++) {
                variable_struct_set(global.shop_owned, _owned[i], true);
            }
        }                                                          // new player: 0 coins, nothing owned
        global.progress_loaded = true;
        global.progress_error  = "";
    } else {
        global.progress_save_id = -1;
        global.progress_error   = _ok ? "" : "COULD NOT SAVE PROGRESS";
    }
}