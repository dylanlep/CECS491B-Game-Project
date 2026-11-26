//obj_leaderboard - Draw

draw_set_font(fnt_pixel);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_aqua);
draw_text(room_width / 2, 16, "LEADERBOARD");



if (loading_status != "") {
    draw_set_halign(fa_center);
    draw_set_color(c_white);
    draw_text(room_width / 2, room_height / 2, loading_status);
	
} else {
    var _start_y = 45;
    var _spacing = 14; 
    
	var _col_rank_x  = 20;
    var _col_level_x = room_width - 80;
    var _col_xp_x    = room_width - 20;
	
	
    draw_set_color(c_yellow);
    draw_set_halign(fa_left);
    draw_text(_col_rank_x, _start_y, "RNK  PLAYER");
    
    draw_set_halign(fa_center);
    draw_text(_col_level_x, _start_y, "LVL");
	
	draw_set_halign(fa_right);
    draw_text(_col_xp_x, _start_y, "XP");
    
    draw_set_color(c_white);
	
    for (var i = 0; i < array_length(leaderboard_list); i++) {
	    var _row_y = _start_y + 16 + (i * _spacing);
	    var _player = leaderboard_list[i];
    
		
	    var _name = variable_struct_exists(_player, "username") ? string(_player.username) : "Unknown Player";
		var _xp_val = variable_struct_exists(_player, "xp") ? _player.xp : 0;
		
	    var _lvl_calc = string(floor(_xp_val / 100) + 1);
	    var _xp_str = string(_xp_val);
	    var _rank  = string(i + 1);
    
	    if (i < 9) _rank = " " + _rank;
		
		//shortens long names...
		if (string_length(_name) > 12) {
            _name = string_copy(_name, 1, 9) + "...";
        }
    
	    //rank & name
	    draw_set_halign(fa_left);
	    draw_text(_col_rank_x, _row_y, _rank + ".  " + _name);
		
		//lvl
		draw_set_halign(fa_center);
	    draw_text(_col_level_x, _row_y, _lvl_calc);
		
		//xp
	    draw_set_halign(fa_right);
	    draw_text(_col_xp_x, _row_y, _xp_str);
    }
	
	
	
	//Current user's ranking display...
	if (user_rank_struct != undefined && is_struct(user_rank_struct)) {
		//
		var _user_ranking = user_rank_struct;
		
		var _panel_w = room_width - 40;
        var _panel_h = 20;
        var _panel_x = 20;
        var _panel_y = room_height - _panel_h - 26;
        
        
        draw_set_color(c_dkgrey);
        draw_rectangle(_panel_x, _panel_y, _panel_x + _panel_w, _panel_y + _panel_h, false);
        
        draw_set_color(c_aqua);
        draw_rectangle(_panel_x, _panel_y, _panel_x + _panel_w, _panel_y + _panel_h, true);
		
        
        var _my_nm  = variable_struct_exists(_user_ranking, "username") ? string(_user_ranking.username) : "You";
        var _my_xp  = variable_struct_exists(_user_ranking, "xp") ? _user_ranking.xp : 0;
		var _my_rk = "-";
		var _my_lvl = "1";
		
		
        if (_my_xp <= 0) {
            _my_rk  = "NONE";
            _my_lvl = "1";
			
        } else {
            _my_rk  = variable_struct_exists(_user_ranking, "my_rank") ? string(_user_ranking.my_rank) + "." : "-"; 
            _my_lvl = string(floor(_my_xp / 100) + 1);
        }
		
		
		//username trim...
		if (string_length(_my_nm) > 12) {
                _my_nm = string_copy(_my_nm, 1, 9) + "...";
            }
		
		
		draw_set_color(c_white);
        draw_set_valign(fa_middle);
        
        //rank & name
        draw_set_halign(fa_left);
		if (_my_xp <= 0) {
            draw_text(_col_rank_x, _panel_y + (_panel_h / 2), _my_rk + " - " + _my_nm);
			
        } else {
            draw_text(_col_rank_x, _panel_y + (_panel_h / 2), _my_rk + "  " + _my_nm);
        }
		
        //lvl & xp
		draw_set_halign(fa_right);
		draw_text(_col_level_x, _panel_y + (_panel_h / 2), "LVL: " + _my_lvl);
        draw_text(_col_xp_x, _panel_y + (_panel_h / 2), string(_my_xp) + " XP");
		
	}
}

draw_set_halign(fa_left); 
draw_set_valign(fa_top);
ui_button_draw(back_x, back_y, back_w, back_h, back_label, hover_back);

