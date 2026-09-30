/// obj_google_login_button - Step

if (mouse_check_button_pressed(mb_left)
    && mouse_x >= btn_x1 && mouse_x <= btn_x2
    && mouse_y >= btn_y1 && mouse_y <= btn_y2) {

    message_text = "Opening Google sign-in...";

    if (!google_login_start()) {
        message_text = "Google sign-in only works in the browser version.";
    }
}