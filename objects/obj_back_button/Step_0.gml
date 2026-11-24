/// obj_back_button - Step

// Ignore clicks while the lesson's Edit Account panel is open
if (instance_exists(obj_game) && obj_game.account_open) {
    hovered = false;
    exit;
}

hovered = ui_mouse_over(btn_x, btn_y, btn_width, btn_height);


//confirm user wants to leave
if (hovered && mouse_check_button_pressed(mb_left)) {
	back_confirm_id = show_question_async("Really want to leave this lesson?");
}