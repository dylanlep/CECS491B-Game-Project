/// obj_main_menu - Create

title_text = "BINARY BRAINS";
menu_buttons = ["START"];
selected_button = 0;
button_width = 96;
button_height = 18;
button_gap = 8;
button_x = (room_width - button_width) / 2;
button_y_start = 102;
message_text = "";

var _streak_data = scr_streak_get_data();
streak_count = _streak_data.count;
streak_completed_today = _streak_data.completed_today;
