// SCRUM-47: freeze the hub while the cheat pop-up is open
if (instance_exists(obj_cheat_popup)) exit;
/// obj_mode_hub - Step

// TEMP TEST (remove before the pull request): F9 shows the cheat pop-up
if (keyboard_check_pressed(vk_f9)) {
    if (!variable_global_exists("test_cheat_attempt")) global.test_cheat_attempt = 0;
    global.test_cheat_attempt++;
    cheat_popup_show(global.test_cheat_attempt, "TESTER");
}

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
        room_goto(rm_profile);
        break;
}