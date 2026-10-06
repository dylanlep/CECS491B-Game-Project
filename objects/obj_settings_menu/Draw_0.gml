//Menu background
draw_self();


//for formatting checkboxes...
var max_text_width = 0;
for (var m = 0; m < op_length; m++) {
    var cur_width = string_width(option[menu_level, m]);
    if (cur_width > max_text_width) {
        max_text_width = cur_width;
    }
}




for (var i = 0; i < op_length; i++) {
	_c = c_white
	if pos = i {_c = c_blue};
	
	//base text string...
    var base_text = option[menu_level, i];
	var cur_x = x+op_border;
	var cur_y = y+op_border+ op_space*i;
	
	
	//----add/remove language----
    if (menu_level == 2 && i != 3) {
		var box_color = (option_selected[1, i] == true) ? c_lime : c_yellow;
        var check_marker = (option_selected[1, i] == true) ? "[X]" : "[ ]";
		
        
		
		//draw_text_color(cur_x, cur_y, check_marker, box_color, box_color, box_color, box_color, 1);
        draw_text_color(cur_x, cur_y, base_text, _c, _c, _c, _c, 1);
		var checkbox_x = cur_x + max_text_width + 30;
		draw_text_color(checkbox_x, cur_y, check_marker, box_color, box_color, box_color, box_color, 1);
        
		
    } 
	
	//---Active lesson---
	else if (menu_level == 3 && base_text != "Back") {
		draw_text_color(cur_x, cur_y, base_text, _c, _c, _c, _c, 1);
        
        if (base_text == global.current_lesson_language) {
            var indicator_x = cur_x + max_text_width + 30;
            draw_text_color(indicator_x, cur_y, "(Active)", c_lime, c_lime, c_lime, c_lime, 1);
		}
	}
	
	//----difficulty selection-----
	else if (menu_level == 4 && base_text != "Back") {
        draw_text_color(cur_x, cur_y, base_text, _c, _c, _c, _c, 1);
        if (base_text == current_difficulty) {
            var indicator_x = cur_x + max_text_width + 30;
            draw_text_color(indicator_x, cur_y, "(Active)", c_lime, c_lime, c_lime, c_lime, 1);
        }
    }
	
	
	else {
		draw_text_color(cur_x, cur_y, base_text, _c, _c, _c, _c, 1);
	}
	
	//draw_text_color(x+op_border, y+op_border + op_space*i, option[menu_level, i], _c, _c, _c, _c, 1);
}

