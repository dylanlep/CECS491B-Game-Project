/// obj_profile - Step Event

if (edit_open) {
    // ---------------- Edit Account popup ----------------
    hover_save   = ui_mouse_over(save_x,   popup_btn_y, save_w,   popup_btn_h);
    hover_cancel = ui_mouse_over(cancel_x, popup_btn_y, cancel_w, popup_btn_h);
	
    if (mouse_check_button_pressed(mb_left)) {
        if (ui_mouse_over(field_x, user_y, field_w, field_h)) {
            edit_field = 1;
            keyboard_string = edit_username;
        } else if (ui_mouse_over(field_x, email_y, field_w, field_h)) {
            edit_field = 2;
            keyboard_string = edit_email;
        } else if (ui_mouse_over(field_x, pass_y, field_w, field_h)) {
            edit_field = 3;
            keyboard_string = edit_password;
        } else if (hover_save) {
            submit_edit();
        } else if (hover_cancel) {
            edit_open = false;
            edit_field = 0;
        } else {
            edit_field = 0;
        }
    }

    // Typing goes into the active field
    if (edit_field == 1) {
        if (string_length(keyboard_string) > 20)  keyboard_string = string_copy(keyboard_string, 1, 20);
        edit_username = keyboard_string;
    } else if (edit_field == 2) {
        if (string_length(keyboard_string) > 64)  keyboard_string = string_copy(keyboard_string, 1, 64);
        edit_email = keyboard_string;
    } else if (edit_field == 3) {
        if (string_length(keyboard_string) > 128) keyboard_string = string_copy(keyboard_string, 1, 128);
        edit_password = keyboard_string;
    }

    if (keyboard_check_pressed(vk_tab)) {
        edit_field = (edit_field >= 3 || edit_field <= 0) ? 1 : edit_field + 1;
        if (edit_field == 1) keyboard_string = edit_username;
        if (edit_field == 2) keyboard_string = edit_email;
        if (edit_field == 3) keyboard_string = edit_password;
    }

    if (keyboard_check_pressed(vk_enter))  submit_edit();
    if (keyboard_check_pressed(vk_escape)) { edit_open = false; edit_field = 0; }

    // Nothing else on screen reacts while the popup is open
    hover_edit = false;
    hover_back = false;
	hover_delete = false;
    exit;
}

// ---------------- Main profile screen ----------------
hover_edit = ui_mouse_over(edit_x, edit_y, edit_w, edit_h);
hover_back = ui_mouse_over(back_x, back_y, back_w, back_h);
hover_delete = ui_mouse_over(delete_x, delete_y, delete_w, delete_h);

if (mouse_check_button_pressed(mb_left)) {
    if (hover_back) {
        room_goto(return_room);
    } else if (hover_edit) {
        if (progress_token() == "") {
            profile_message = "PLEASE LOG IN AGAIN";
            profile_message_color = c_red;
        } else if (profile_load_id != -1) {
            profile_message = "STILL LOADING...";
            profile_message_color = c_yellow;
        } else {
            edit_open     = true;
            edit_field    = 0;
            edit_username = display_username;   // prefilled so you only change what you want
            edit_email    = display_email;
            edit_password = "";
            edit_message  = "";
            profile_message = "";
        }
    } else if (hover_delete) {
		global.delete_confirm_id = show_question_async("Confirm account deletion?");
	}
}
if (keyboard_check_pressed(vk_escape)) room_goto(return_room);