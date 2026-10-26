/// obj_back_button - Draw

// Hide while the Edit Account panel covers the screen
if (instance_exists(obj_game) && (obj_game.account_open || obj_game.level_complete_open)) exit;

ui_button_draw(btn_x, btn_y, btn_width, btn_height, btn_label, hovered);