/// obj_logout_button - Step

if (!is_logging_out
    && mouse_check_button_pressed(mb_left)
    && mouse_x >= btn_x1 && mouse_x <= btn_x2
    && mouse_y >= btn_y1 && mouse_y <= btn_y2) {

    logout_request_id = logout_send_request();

    if (logout_request_id == -1) {
        // No token saved: nothing to end on Supabase, just log out on this device.
        logout_finish("YOU HAVE BEEN LOGGED OUT");
    } else {
        // Wait for Supabase's answer, but no longer than 3 seconds.
        is_logging_out = true;
        alarm[0] = game_get_speed(gamespeed_fps) * LOGOUT_TIMEOUT_SECONDS;
    }
}