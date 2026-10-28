/// scr_player_progress
/// Coins, XP and shop items for the logged-in player (Supabase table: player_progress).
/// SCRUM-29: loading.  SCRUM-47: buying and earning now go through Supabase server
/// functions (buy_item, earn_coins, report_cheat), so the game never writes coin
/// totals itself. Dylan H's XP / level functions are unchanged.

#macro XP_PER_LEVEL 100      // every 100 XP = 1 level
#macro EARN_MAX_SEND 100     // most coins the game asks for per lesson visit (server limit is the same)

/// Makes sure every global this script uses exists.
function progress_init() {
    if (!variable_global_exists("coins"))                 global.coins = 0;
    if (!variable_global_exists("total_xp"))              global.total_xp = 0;
    if (!variable_global_exists("shop_owned"))            global.shop_owned = {};
    if (!variable_global_exists("progress_loaded"))       global.progress_loaded = false;
    if (!variable_global_exists("progress_load_id"))      global.progress_load_id = -1;
    if (!variable_global_exists("progress_save_id"))      global.progress_save_id = -1;   // kept for older code
    if (!variable_global_exists("progress_error"))        global.progress_error = "";
    // SCRUM-47
    if (!variable_global_exists("progress_buy_id"))       global.progress_buy_id = -1;
    if (!variable_global_exists("progress_earn_id"))      global.progress_earn_id = -1;
    if (!variable_global_exists("progress_report_id"))    global.progress_report_id = -1;
    if (!variable_global_exists("progress_buy_item"))     global.progress_buy_item = "";
    if (!variable_global_exists("progress_buy_result"))   global.progress_buy_result = "";
    if (!variable_global_exists("progress_server_coins")) global.progress_server_coins = 0;
    if (!variable_global_exists("progress_server_xp"))    global.progress_server_xp = 0;
}

/// Current level (starts at 1).
function progress_level() {
    return floor(global.total_xp / XP_PER_LEVEL) + 1;
}

/// XP earned inside the current level (0 to XP_PER_LEVEL - 1).
function progress_xp_in_level() {
    return global.total_xp mod XP_PER_LEVEL;
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

/// Calls a Supabase server function. Returns the request id, or -1.
function progress_rpc(_function, _args) {
    var _token = progress_token();
    if (_token == "") return -1;
    var _h = progress_headers(_token);
    var _id = http_request(SUPABASE_URL + "/rest/v1/rpc/" + _function, "POST", _h, json_stringify(_args));
    ds_map_destroy(_h);
    return _id;
}

/// Ask Supabase for this player's coins, XP and owned items (reading is still allowed).
function progress_load() {
    progress_init();
    var _token = progress_token();
    if (_token == "" || global.progress_load_id != -1) return;   // not logged in, or already loading

    var _h = progress_headers(_token);
    global.progress_load_id = http_request(
        SUPABASE_URL + "/rest/v1/player_progress?select=coins,owned,xp", "GET", _h, "");
    ds_map_destroy(_h);
}

/// SCRUM-47: the game no longer writes coins/XP directly.
/// Kept so older code still runs. Use progress_buy / progress_earn instead.
function progress_save() {
    show_debug_message("progress_save() is no longer used (SCRUM-47). Use progress_buy / progress_earn.");
}

/// SCRUM-47: coins and XP only ever change from server answers, so if they differ
/// from the last values the server sent, someone edited the game's memory.
/// Puts the real values back, reports it, and returns true.
function progress_tamper_check() {
    if (!global.progress_loaded) return false;
    if (global.coins == global.progress_server_coins
     && global.total_xp == global.progress_server_xp) return false;

    var _details = "coins " + string(global.progress_server_coins) + "->" + string(global.coins)
                 + ", xp " + string(global.progress_server_xp) + "->" + string(global.total_xp);
    global.coins    = global.progress_server_coins;
    global.total_xp = global.progress_server_xp;
    global.progress_report_id = progress_rpc("report_cheat", { p_reason: "memory_edit", p_details: _details });
    return true;
}

/// Asks the server to buy an item.
/// Returns straight away: "owned" / "poor" (quick check), "pending" (sent; the answer
/// arrives later in global.progress_buy_result), "busy", "cheat", or "error".
function progress_buy(_name, _price) {
    progress_init();
    if (progress_tamper_check()) return "cheat";
    if (global.progress_buy_id != -1) return "busy";
    if (variable_struct_exists(global.shop_owned, _name)) return "owned";
    if (global.coins < _price) return "poor";

    global.progress_buy_item   = _name;
    global.progress_buy_result = "";
    global.progress_buy_id     = progress_rpc("buy_item", { p_item: _name });
    return (global.progress_buy_id == -1) ? "error" : "pending";
}

/// Asks the server to add earned coins + XP (1 XP = 1 coin). The server applies the limits.
function progress_earn(_amount) {
    progress_init();
    if (progress_tamper_check()) return;
    if (_amount <= 0) return;
    global.progress_earn_id = progress_rpc("earn_coins", { p_amount: min(floor(_amount), EARN_MAX_SEND) });
}

/// Copies coins / XP / owned items from a server answer into the game.
function progress_apply(_data) {
    if (variable_struct_exists(_data, "coins") && is_numeric(_data.coins)) global.coins    = _data.coins;
    if (variable_struct_exists(_data, "xp")    && is_numeric(_data.xp))    global.total_xp = _data.xp;
    if (variable_struct_exists(_data, "owned") && is_array(_data.owned)) {
        global.shop_owned = {};
        for (var i = 0; i < array_length(_data.owned); i++) {
            variable_struct_set(global.shop_owned, _data.owned[i], true);
        }
    }
    global.progress_server_coins = global.coins;     // remember what the server says
    global.progress_server_xp    = global.total_xp;
}

/// Forget this player's progress on this device (logout). Supabase keeps it.
function progress_clear() {
    global.coins                 = 0;
    global.total_xp              = 0;
    global.shop_owned            = {};
    global.progress_loaded       = false;
    global.progress_load_id      = -1;
    global.progress_save_id      = -1;
    global.progress_buy_id       = -1;
    global.progress_earn_id      = -1;
    global.progress_report_id    = -1;
    global.progress_buy_item     = "";
    global.progress_buy_result   = "";
    global.progress_server_coins = 0;
    global.progress_server_xp    = 0;
    global.progress_error        = "";
}

/// Call this from the Async - HTTP event of any object on screen.
function progress_handle_async() {
    progress_init();
    var _id        = async_load[? "id"];
    var _is_load   = (_id == global.progress_load_id);
    var _is_buy    = (_id == global.progress_buy_id);
    var _is_earn   = (_id == global.progress_earn_id);
    var _is_report = (_id == global.progress_report_id);
    if (!_is_load && !_is_buy && !_is_earn && !_is_report) return;   // not ours
    if (async_load[? "status"] == 1) return;                          // still downloading

    if (_is_load)   global.progress_load_id   = -1;
    if (_is_buy)    global.progress_buy_id    = -1;
    if (_is_earn)   global.progress_earn_id   = -1;
    if (_is_report) global.progress_report_id = -1;

    var _http = async_load[? "http_status"];
    var _ok   = async_load[? "status"] == 0 && _http >= 200 && _http < 300;
    var _data = undefined;
    try { _data = json_parse(async_load[? "result"]); } catch (_e) { _data = undefined; }

    if (!_ok) {
        global.progress_error = _is_load ? "COULD NOT LOAD PROGRESS" : "COULD NOT SAVE (" + string(_http) + ")";
        if (_is_buy) global.progress_buy_result = "error";
        show_debug_message("Progress request failed: HTTP " + string(_http) + " " + string(async_load[? "result"]));
        return;
    }
    global.progress_error = "";

    // --- Load: a list with 0 rows (new player) or 1 row ---
    if (_is_load) {
        global.coins = 0;  global.total_xp = 0;  global.shop_owned = {};
        if (is_array(_data) && array_length(_data) > 0) progress_apply(_data[0]);
        else progress_apply({});
        global.progress_loaded = true;
        return;
    }

    // --- Buy / earn / report: one answer from a server function ---
    if (!is_struct(_data)) return;
    progress_apply(_data);
    global.progress_loaded = true;

    var _status = variable_struct_exists(_data, "status") ? _data.status : "";
    if (_status == "cheat") {
        cheat_popup_show(_data.attempt, _data.username);   // the funny pop-up (scr_cheat)
        if (_is_buy) global.progress_buy_result = "cheat";
        return;
    }
    if (_is_buy) global.progress_buy_result = _status;     // "bought", "owned" or "poor"
    if (_is_earn && _status == "limited") global.progress_error = "DAILY COIN LIMIT REACHED";
}