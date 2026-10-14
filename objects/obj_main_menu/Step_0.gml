/// obj_main_menu - Step

var _count   = array_length(buttons);
var _clicked = -1;   // which button was activated this frame (-1 = none)

// --- Keyboard: arrow keys move, Enter/Space activates ---
if (keyboard_check_pressed(vk_down)) selected = (selected + 1) mod _count;
if (keyboard_check_pressed(vk_up))   selected = (selected - 1 + _count) mod _count;
if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) _clicked = selected;

// --- Mouse: hovering highlights, clicking activates ---
for (var i = 0; i < _count; i++) {
    var _y = btn_y0 + i * (btn_height + btn_spacing);
    if (ui_mouse_over(btn_x, _y, btn_width, btn_height)) {
        selected = i;
        if (mouse_check_button_pressed(mb_left)) _clicked = i;
    }
}

// --- Do what the chosen button says ---
switch (_clicked) {
    case 0: // START
        var _logged_in = variable_global_exists("supabase_access_token")
                      && global.supabase_access_token != "";
        if (_logged_in) {
            room_goto(rm_lesson);   // SCRUM-15: change to the Game Mode Hub
        } else {
            room_goto(rm_login);
        }
        break;

    case 1: // SETTINGS
        message_text = "SETTINGS COMING SOON";
        break;
}