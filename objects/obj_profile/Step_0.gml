/// obj_profile - Step Event

if (mouse_check_button_pressed(mb_left)) {
    var _mx = mouse_x;
    var _my = mouse_y;
    
    // Match the exact button geometry from the Draw Event
    var box_h = 560;
    var box_y = 110;
    var btn_w = 260;
    var btn_h = 56;
    var btn_y = box_y + box_h + 20;
    
    // 1. Log Out Button Bounds Check
    var logout_btn_x = room_width / 2 + 20;
    if (_mx >= logout_btn_x && _mx <= logout_btn_x + btn_w && _my >= btn_y && _my <= btn_y + btn_h) {
        // Clear session variables
        global.access_token = "";
        global.user_id = "";
        global.username = "";
        global.user_email = "";
        
        // Transition back to your login room (adjust "rm_login" to your actual login room name)
        room_goto(rm_login);
        exit;
    }
    
    // 2. Edit Account Button Bounds Check (Placeholder)
    var edit_btn_x = room_width / 2 - btn_w - 20;
    if (_mx >= edit_btn_x && _mx <= edit_btn_x + btn_w && _my >= btn_y && _my <= btn_y + btn_h) {
        show_debug_message("Edit Account button clicked.");
        // Add your edit account popup or transition logic here later
    }
}