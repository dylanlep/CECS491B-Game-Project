/// obj_back_button - Step

// Ignore clicks while the lesson's Edit Account panel is open
if (instance_exists(obj_game) && obj_game.account_open) {
    hovered = false;
    exit;
}

hovered = ui_mouse_over(btn_x, btn_y, btn_width, btn_height);
if (hovered && mouse_check_button_pressed(mb_left)) {
    room_goto(rm_mode_hub);
}