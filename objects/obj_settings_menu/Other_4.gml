//obj_settings_menu - room start

is_open = false;
menu_level = 0;
pos = 0;


//decide if dropdown menu should show up
if (room = rm_login || room = rm_main_menu || room = rm_lesson) {
	visible = true;
}
else {
	visible = false;
}



//repositioning
if (room == rm_login) {
	y = 10
	
}
if (room == rm_lesson) {
    x = room_width - 260; 
    y = 170;
}

