/// obj_profile - Step Event

var mx = mouse_x;
var my = mouse_y;

// Handle back/close button click
if (mouse_check_button_pressed(mb_left)) {
    var over_back_btn = (mx >= btn_x && mx <= btn_x + btn_width && my >= btn_y && my <= btn_y + btn_height);
    
    if (over_back_btn) {
        // Return to main menu or previous room
        room_goto(rm_main_menu); // Change to your target room
    }
}