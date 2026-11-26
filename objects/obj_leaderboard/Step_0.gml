//obj_leaderboard - Step

hover_back = ui_mouse_over(back_x, back_y, back_w, back_h);

if (mouse_check_button_pressed(mb_left)) {
    if (hover_back) {
        room_goto(return_room);
    } 
}


if (keyboard_check_pressed(vk_escape)) room_goto(return_room);

