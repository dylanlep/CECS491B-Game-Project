/// obj_mode_hub - Create
// Game Mode Hub (SCRUM-15): home screen after login.
// 5 game modes in a column, SHOP + PROFILE in a row at the bottom.
// (LOGOUT is your existing obj_logout_button, placed in the room.)

title_text = "CHOOSE A MODE";

var _modes  = ["STORY", "PRACTICE", "CHALLENGE", "QUIZ", "BOSS"];
var _extras = ["SHOP", "PROFILE"];

// Every button gets its own label, x, y and width, stored in matching lists.
btn_label = [];
btn_x     = [];
btn_y     = [];
btn_w     = [];
btn_h     = 16;
mode_count = array_length(_modes);   // buttons 0-4 are modes, 5+ are extras

// --- Mode column: same width for all, centered ---
var _w = 110;
for (var i = 0; i < mode_count; i++) _w = max(_w, ui_button_width(_modes[i]));
var _x = (room_width - _w) / 2;
for (var i = 0; i < mode_count; i++) {
    array_push(btn_label, _modes[i]);
    array_push(btn_x, _x);
    array_push(btn_y, 40 + i * 21);      // 16 px button + 5 px gap
    array_push(btn_w, _w);
}

// --- Bottom row: each sized to its label, whole row centered ---
var _gap = 8;
var _row_w = 0;
for (var i = 0; i < array_length(_extras); i++) _row_w += ui_button_width(_extras[i]);
_row_w += _gap * (array_length(_extras) - 1);
var _rx = (room_width - _row_w) / 2;
for (var i = 0; i < array_length(_extras); i++) {
    var _ew = ui_button_width(_extras[i]);
    array_push(btn_label, _extras[i]);
    array_push(btn_x, _rx);
    array_push(btn_y, 192);
    array_push(btn_w, _ew);
    _rx += _ew + _gap;
}

selected     = 0;    // STORY highlighted first
message_text = "";


// SCRUM-29: load this player's coins + owned items (once per login)
progress_init();
if (!global.progress_loaded) progress_load();