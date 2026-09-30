/// obj_google_login_button - Create
// A self-contained "Sign in with Google" button.
// Drop one into whichever login room the team keeps.

btn_width  = 280;
btn_height = 50;
btn_x1 = room_width / 2 - btn_width / 2;
btn_y1 = 580;
btn_x2 = btn_x1 + btn_width;
btn_y2 = btn_y1 + btn_height;

message_text = "";

// Did the player just come back from Google?
var _result = google_login_check_return();

if (_result.status == "success") {
    room_goto(rm_lesson);
} else if (_result.status == "error") {
    message_text = _result.message;
}