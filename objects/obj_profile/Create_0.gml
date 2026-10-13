/// obj_profile - Create Event

// Layout dimensions
panel_width  = 400;
panel_height = 320;

panel_x = room_width/2 - panel_width/2;
panel_y = room_height/2 - panel_height/2;

// Button dimensions
btn_width  = 160;
btn_height = 40;

btn_x = room_width/2 - btn_width/2;
btn_y = panel_y + panel_height - 60;

// Placeholder profile data (fallback if globals aren't set yet)
display_username = (variable_global_exists("username") && global.username != "") ? global.username : "Player_One";
display_email    = (variable_global_exists("email") && global.email != "") ? global.email : "user@example.com";
display_id       = (variable_global_exists("user_id") && global.user_id != "") ? global.user_id : "N/A (Offline)";