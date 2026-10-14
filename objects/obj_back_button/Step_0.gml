/// obj_back_button - Step

// Ignore clicks while the lesson's Edit Account panel is open
if (instance_exists(obj_game) && obj_game.account_open) {
    hovered = false;
    exit;
}

hovered = ui_mouse_over(btn_x, btn_y, btn_width, btn_height);
if (hovered && mouse_check_button_pressed(mb_left)) {

    // SCRUM-29: bank this lesson's XP as coins (1 XP = 1 coin), then save
    if (instance_exists(obj_game)) {
        var _earned = 0;
        for (var i = 0; i < array_length(obj_game.language_scores); i++) {
            _earned += obj_game.language_scores[i];
        }
        progress_earn(_earned);
    }

    room_goto(rm_mode_hub);
}