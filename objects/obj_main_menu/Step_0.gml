/// obj_main_menu - Step

var _button_count = array_length(menu_buttons);
var _activate = -1;

if (keyboard_check_pressed(vk_down)) {
    selected_button = (selected_button + 1) mod _button_count;
}
if (keyboard_check_pressed(vk_up)) {
    selected_button = (selected_button - 1 + _button_count) mod _button_count;
}
if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
    _activate = selected_button;
}

for (var i = 0; i < _button_count; i++) {
    var _button_y = button_y_start + i * (button_height + button_gap);
    if (mouse_x >= button_x && mouse_x <= button_x + button_width
    && mouse_y >= _button_y && mouse_y <= _button_y + button_height) {
        selected_button = i;
        if (mouse_check_button_pressed(mb_left)) _activate = i;
    }
}

if (_activate == 0) {
    if (variable_global_exists("supabase_access_token")
    && global.supabase_access_token != "") {
        room_goto(rm_lesson);
    } else {
        room_goto(rm_login);
    }
}
