/// scr_streak
/// Per-user daily lesson streaks stored in public.profiles through Supabase RPCs.

#macro STREAK_NOTICE_FRAMES 210

function scr_streak_init() {
    if (!variable_global_exists("user_streak")) global.user_streak = 0;
    if (!variable_global_exists("streak_loaded")) global.streak_loaded = false;
    if (!variable_global_exists("streak_load_id")) global.streak_load_id = -1;
    if (!variable_global_exists("streak_record_id")) global.streak_record_id = -1;
    if (!variable_global_exists("streak_record_queued")) global.streak_record_queued = false;
    if (!variable_global_exists("streak_completed_today")) global.streak_completed_today = false;
    if (!variable_global_exists("streak_notice")) global.streak_notice = false;
    if (!variable_global_exists("streak_notice_timer")) global.streak_notice_timer = 0;
    if (!variable_global_exists("streak_error")) global.streak_error = "";
}

/// Forget cached streak state when the signed-in account changes or logs out.
function scr_streak_clear() {
    scr_streak_init();
    global.user_streak = 0;
    global.streak_loaded = false;
    global.streak_load_id = -1;
    global.streak_record_id = -1;
    global.streak_record_queued = false;
    global.streak_completed_today = false;
    global.streak_notice = false;
    global.streak_notice_timer = 0;
    global.streak_error = "";
}

/// Load the current account's streak. The server resets an expired streak and
/// tells the game whether to show the one-time lost-streak message.
function scr_streak_load() {
    scr_streak_init();
    if (progress_token() == "") return -1;
    if (global.streak_loaded || global.streak_load_id != -1) return global.streak_load_id;

    global.streak_error = "";
    global.streak_load_id = progress_rpc("get_streak_status", {});
    if (global.streak_load_id == -1) global.streak_error = "COULD NOT LOAD STREAK";
    return global.streak_load_id;
}

/// Record one completed lesson. The server counts at most one lesson per UTC day.
function scr_streak_record_lesson() {
    scr_streak_init();
    if (progress_token() == "") return -1;

    // Let the initial server check finish first so its older response cannot
    // overwrite the streak value returned by this lesson completion.
    if (global.streak_load_id != -1) {
        global.streak_record_queued = true;
        return global.streak_load_id;
    }

    if (global.streak_record_id != -1) {
        global.streak_record_queued = true;
        return global.streak_record_id;
    }

    global.streak_error = "";
    global.streak_record_id = progress_rpc("record_lesson_streak", {});
    if (global.streak_record_id == -1) global.streak_error = "COULD NOT SAVE STREAK";
    return global.streak_record_id;
}

/// Return cached streak data for profile UI.
function scr_streak_get_data() {
    scr_streak_init();
    return {
        count: global.user_streak,
        completed_today: global.streak_completed_today,
        loading: !global.streak_loaded && global.streak_error == "",
        error: global.streak_error
    };
}

/// Consume an HTTP result if it belongs to a streak RPC. Returns true when it
/// handled the event, allowing several objects to safely share the async event.
function scr_streak_handle_async() {
    scr_streak_init();

    var _request_id = async_load[? "id"];
    var _is_load = (_request_id == global.streak_load_id);
    var _is_record = (_request_id == global.streak_record_id);
    if (!_is_load && !_is_record) return false;
    if (async_load[? "status"] == 1) return true;

    if (_is_load) global.streak_load_id = -1;
    if (_is_record) global.streak_record_id = -1;

    var _http = async_load[? "http_status"];
    var _ok = (async_load[? "status"] == 0) && _http >= 200 && _http < 300;
    var _data = undefined;
    try { _data = json_parse(async_load[? "result"]); } catch (_e) { _data = undefined; }

    if (!_ok || !is_struct(_data)
    || !variable_struct_exists(_data, "status") || _data.status != "ok") {
        global.streak_error = _is_load ? "COULD NOT LOAD STREAK" : "COULD NOT SAVE STREAK";
        show_debug_message("Streak request failed: HTTP " + string(_http) + " " + string(async_load[? "result"]));
    } else {
        if (variable_struct_exists(_data, "streak") && is_numeric(_data.streak)) {
            global.user_streak = max(0, floor(_data.streak));
        }
        global.streak_loaded = true;
        global.streak_error = "";

        if (_is_load) {
            global.streak_completed_today = variable_struct_exists(_data, "completed_today")
                && _data.completed_today;
            if (variable_struct_exists(_data, "streak_lost") && _data.streak_lost) {
                global.streak_notice = true;
                global.streak_notice_timer = STREAK_NOTICE_FRAMES;
            }
        } else {
            global.streak_completed_today = true;
        }

        if (variable_instance_exists(id, "profile_streak")) {
            profile_streak = global.user_streak;
        }
    }

    if (global.streak_record_queued && (_is_load || _is_record)) {
        global.streak_record_queued = false;
        scr_streak_record_lesson();
    }

    return true;
}
