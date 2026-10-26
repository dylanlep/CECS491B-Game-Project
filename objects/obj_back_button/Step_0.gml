/// obj_back_button - Step

// Ignore clicks while an overlay (Edit Account / Level Complete) is open
if (instance_exists(obj_game) && (obj_game.account_open || obj_game.level_complete_open)) {
    hovered = false;
    exit;
}

hovered = ui_mouse_over(btn_x, btn_y, btn_width, btn_height);
if (hovered && mouse_check_button_pressed(mb_left)) {
    // Coins are now awarded the moment a level is completed (obj_game),
    // so there's nothing to bank here anymore.
    room_goto(rm_mode_hub);
}