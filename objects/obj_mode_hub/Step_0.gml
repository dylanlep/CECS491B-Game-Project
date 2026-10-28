/// obj_mode_hub - Step

// SCRUM-47: freeze the hub while the cheat pop-up is open
if (instance_exists(obj_cheat_popup)) exit;

// TEMP TEST (remove before the pull request) -------------------------
// F9  = show the pop-up directly (no server involved)
// F10 = pretend coins were edited in memory (then try to buy something in the SHOP)
// F11 = send an impossible reward (99999 coins) to the server
// F12 = try to buy an item that doesn't exist
if (keyboard_check_pressed(vk_f9)) {
    if (!variable_global_exists("test_cheat_attempt")) global.test_cheat_attempt = 0;
    global.test_cheat_attempt++;
    cheat_popup_show(global.test_cheat_attempt, "TESTER");
}
if (keyboard_check_pressed(vk_f10)) global.coins = 9999;
if (keyboard_check_pressed(vk_f11)) global.progress_earn_id = progress_rpc("earn_coins", { p_amount: 99999 });
if (keyboard_check_pressed(vk_f12)) {
    global.progress_buy_item = "GOLDEN UNICORN";
    global.progress_buy_id   = progress_rpc("buy_item", { p_item: "GOLDEN UNICORN" });
}
// ---------------------------------------------------------------------

var _count   = array_length(btn_label);
var _clicked = -1;

// --- Keyboard: arrows move through all buttons, Enter/Space activates ---
if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(vk_right)) selected = (selected + 1) mod _count;
if (keyboard_check_pressed(vk_up)   || keyboard_check_pressed(vk_left))  selected = (selected - 1 + _count) mod _count;
if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) _clicked = selected;

// --- Mouse: hover highlights, click activates ---
for (var i = 0; i < _count; i++) {
    if (ui_mouse_over(btn_x[i], btn_y[i], btn_w[i], btn_h)) {
        selected = i;
        if (mouse_check_button_pressed(mb_left)) _clicked = i;
    }
}

if (_clicked == -1) exit;   // nothing chosen this frame
var _label = btn_label[_clicked];

// --- Game modes (SRS Use Case 3: Select Game Mode) ---
if (_clicked < mode_count) {
    global.selected_mode = _label;      // remembered for the lesson to use later
    if (_label == "STORY") {
        room_goto(rm_lesson);
    } else {
        message_text = _label + " MODE COMING SOON";
    }
    exit;
}

// --- Bottom row ---
switch (_label) {
    case "SHOP":
        room_goto(rm_shop);   // SCRUM-29
        break;
    case "PROFILE":
        global.profile_return_room = room;   // Dylan H: lets the profile's BACK return here
        room_goto(rm_profile);
        break;
}