/// obj_google_login_button - Create
// "Sign in with Google" button, pixel style to match obj_login (256x240 room).

   draw_set_font(fnt_pixel);
   btn_width  = string_width("SIGN IN WITH GOOGLE") + 24;   // text width + 8 px padding each side;
btn_height = 18;                          // same height as the LOG IN button
btn_x1 = (room_width - btn_width) / 2;
btn_y1 = 204;                             // just below obj_login's messages
btn_x2 = btn_x1 + btn_width;
btn_y2 = btn_y1 + btn_height;

message_text  = "";
message_color = c_red;

// SCRUM-9: did the logout button leave a message for us?
if (variable_global_exists("login_screen_message") && global.login_screen_message != "") {
    message_text  = global.login_screen_message;
    message_color = c_lime;                 // green = good news
    global.login_screen_message = "";       // show it only once
}

// Did the player just come back from Google?
var _result = google_login_check_return();

if (_result.status == "success") {
    room_goto(rm_lesson);
} else if (_result.status == "error") {
    message_text  = _result.message;
    message_color = c_red;
}