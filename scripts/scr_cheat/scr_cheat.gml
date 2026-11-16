/// scr_cheat
/// SCRUM-47: the comedic "cheat detected" pop-up.
/// To add or change jokes, edit the messages below. Nothing else needs to change.

/// Random jokes for a first attempt (no name used yet).
function cheat_first_messages() {
    return [
        "NICE TRY, HACKER.\nTHE ROBOTS SAW EVERYTHING.",
        "ERROR 404:\nYOUR HONESTY WAS NOT FOUND.",
        "if (cheating) {\n    coins = 0; // lol\n}",
        "YOUR COINS HAVE BEEN\nSENT TO THE RECYCLE BIN.",
        "SYNTAX ERROR:\nUNEXPECTED SHENANIGANS\nON LINE 1.",
        "THE DEBUGGER FOUND A BUG.\nTHE BUG IS YOU.",
        "CTRL + Z.\nYOUR CHEAT HAS BEEN UNDONE."
    ];
}

/// The message for this attempt number (1 = first time), using the player's name.
function cheat_message(_attempt, _name) {
    var _n = string_upper(string_copy(_name, 1, 12));   // max 12 letters, in capitals
    if (_n == "") _n = "PLAYER";

    switch (_attempt) {
        case 1:
            var _list = cheat_first_messages();
            return _list[irandom(array_length(_list) - 1)];
        case 2:  return _n + ". NOT AGAIN.\nTHE ROBOTS ARE GETTING TIRED.";
        case 3:  return _n + ", THE ROBOTS HAVE STARTED\nA GROUP CHAT ABOUT YOU.";
        case 4:  return _n + "... SERIOUSLY?\nTHIS IS ATTEMPT #4.";
        default: return "INFINITE LOOP DETECTED:\nwhile (" + _n + ") cheat();";
    }
}

/// Shows the pop-up (only one at a time).
function cheat_popup_show(_attempt, _name) {
    if (instance_exists(obj_cheat_popup)) return;
    var _popup = instance_create_depth(0, 0, -20000, obj_cheat_popup);
    _popup.message = cheat_message(_attempt, _name);
}



// =====================================================================
// SCRUM-47 DEMO KEYS - an easy way to SHOW the anti-cheat (class demo / testing).
// On the Mode Hub:  1 = pop-up only   2 = fake coins (then BUY in the SHOP)
//                   3 = impossible reward   4 = fake item
// Set CHEAT_DEMO_KEYS to false to turn the keys and the hint line off.
// (Safe to leave on: every cheat is still caught and logged by the server.)
// =====================================================================
#macro CHEAT_DEMO_KEYS true

function cheat_demo_keys() {
    if (!CHEAT_DEMO_KEYS) return;

    // 1 = show the pop-up directly (no server involved)
    if (keyboard_check_pressed(ord("1"))) {
        if (!variable_global_exists("demo_cheat_attempt")) global.demo_cheat_attempt = 0;
        global.demo_cheat_attempt++;
        var _name = "TESTER";
        if (variable_global_exists("username") && is_string(global.username) && global.username != "") _name = global.username;
        cheat_popup_show(global.demo_cheat_attempt, _name);
    }
    // 2 = pretend coins were edited in memory (caught on the next BUY in the SHOP)
    if (keyboard_check_pressed(ord("2"))) global.coins = 9999;
    // 3 = ask the server for an impossible reward
    if (keyboard_check_pressed(ord("3"))) global.progress_earn_id = progress_rpc("earn_coins", { p_amount: 99999 });
    // 4 = try to buy an item that doesn't exist
    if (keyboard_check_pressed(ord("4"))) {
        global.progress_buy_item = "GOLDEN UNICORN";
        global.progress_buy_id   = progress_rpc("buy_item", { p_item: "GOLDEN UNICORN" });
    }
}

/// Small grey hint in the bottom-left corner of the Mode Hub (left of LOGOUT),
/// so testers know the keys exist.
function cheat_demo_draw() {
    if (!CHEAT_DEMO_KEYS) return;
    var _t = "DEMO: 1 POP-UP  2 FAKE COINS  3 BIG REWARD  4 FAKE ITEM";
    draw_set_font(fnt_pixel);
    var _max_w = room_width - 84;                               // leave room for LOGOUT on the right
    var _s = min(1, _max_w / max(1, string_width(_t)));
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(c_gray);
    draw_text_transformed(4, room_height - 12, _t, _s, _s, 0);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}