
//Keyboard input

var up_key = 0;
var down_key = 0;
var accept_key = 0;


if (mouse_check_button_pressed(mb_left)) {
    if (mouse_x >= x && mouse_x <= x + width &&
        mouse_y >= y && mouse_y <= y + height) {
        
        global.menu_focus = "language";
        with(obj_login) { active_field = -1; }
    }
}


if (global.menu_focus == "language") {
    up_key = keyboard_check_pressed(vk_up)
    down_key = keyboard_check_pressed(vk_down)
	accept_key = keyboard_check_pressed(vk_space);
} else {
    up_key = 0;
    down_key = 0;
	accept_key = 0;
}



if (accept_key) {
	
switch(menu_level) {
	
	//----general settings----
	case 0:
		switch(pos) {
			//Language settings
			case 0:
				menu_level = 1;
				pos = 0;
				break;
			
			//diffulty section
			case 1:
				menu_level = 4;
				pos = 0;
				break;
			
		}
		break;
	
	
	//----language settings----
	case 1: 
		switch(pos) {

		//add/remove language
		case 0: menu_level = 2; break;
		//select current lesson
		case 1:
			//reset array
			option[3] = [];
			
			var added_count = 0;
                    
            
            if (option_selected[1, 0] == true) { option[3, added_count] = "Python"; added_count++; }
            if (option_selected[1, 1] == true) { option[3, added_count] = "C"; added_count++; }
            if (option_selected[1, 2] == true) { option[3, added_count] = "Java"; added_count++; }
                    
            
            option[3, added_count] = "Back";
			//added_count++;
			
                    
            menu_level = 3; 
            pos = 0;
			op_length = added_count;
			break;
		
		//Back
		case 2:
			menu_level = 0;
			pos = 0;
			break;
	
		}
		break;
		
	
	//----add/remove lang menu----
	//Needs to be able to select multiple lang options (except for back)
	//User needs to have at least one option selected at all times...
	//Show a popup to say user must have one language selected?
	case 2:
		var total_checked = 0;
		if (option_selected[1, 0] == true) total_checked++;
		if (option_selected[1, 1] == true) total_checked++;
		if (option_selected[1, 2] == true) total_checked++;
		
		
		switch(pos) {
			//Add Python
			case 0: 
				if (option_selected[1, 0] == true && total_checked <= 1) {}
				else {
					option_selected[1, 0] = !option_selected[1, 0];
					if (option_selected[1, 0] == false && global.current_lesson_language == "Python") {
						global.current_lesson_language = "None";
					}
				}
				break;
				
			//Add C
			case 1: 
				if (option_selected[1, 1] == true && total_checked <= 1) {}
				else {
					option_selected[1, 1] = !option_selected[1, 1];
					if (option_selected[1, 1] == false && global.current_lesson_language == "C") {
						global.current_lesson_language = "None";
					}
				}
				break;
			
			//Add Java
			case 2:
				if (option_selected[1, 2] == true && total_checked <= 1) {}
				else {
					option_selected[1, 2] = !option_selected[1, 2];
					if (option_selected[1, 2] == false && global.current_lesson_language == "Java") {
						global.current_lesson_language = "None";
					}
				}
				break;
			
			//Go back
			case 3: pos = 0; menu_level = 1; break;
		}
		break;
	
	
	//----select current language lesson----
	case 3:
		var selected_text = option[3, pos];
            
        if (selected_text == "Back") {
            menu_level = 1;
            pos = 1;
        } else {
            global.current_lesson_language = selected_text;
			
			
			//testing wip...
			if (instance_exists(obj_game)) {
                with (obj_game) {
                    for (var i = 0; i < lesson_count; i++) {
                        if (lesson_names[i] == global.current_lesson_language) {
                            current_lesson = i;
                            scr_setup_lesson();
                            break;
                        }
                    }
                }
            }
                
				
        }
		
		break;
	
	
	//----difficulty selection menu----
	case 4:
		var selected_diff = option[4, pos];
            if (selected_diff == "Back") {
                menu_level = 0;
                pos = 1;
            } else {
                current_difficulty = selected_diff;
				//Just store difficulty for now...
            }
            break;
		
}

}


//Update length after changing menu_level
//store # of options in current menu
op_length = array_length(option[menu_level]);


//up_key = keyboard_check_pressed(vk_up);
//down_key = keyboard_check_pressed(vk_down);


pos += down_key - up_key;
if (pos >= op_length) {pos = 0};
if (pos < 0) {pos = op_length-1};
