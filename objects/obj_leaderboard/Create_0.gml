//obj_leaderboard - Create

return_room = variable_global_exists("leaderboard_return_room") ? global.leaderboard_return_room : rm_mode_hub;


back_label = "BACK";
back_w = ui_button_width(back_label);
back_h = 16;
back_x = room_width  - back_w - 4;
back_y = room_height - back_h - 4;

hover_edit = false;
hover_back = false;


leaderboard_list = [];
loading_status = "Loading entries...";
leaderboard_load_id = -1;

user_rank_struct = undefined;
personal_rank_id = -1;

//for users w/0 xp...
if (variable_global_exists("username")) {
    user_rank_struct = {
        my_rank: 0,
        username: global.username,
        xp: 0
    };
}


var _token = progress_token();
var _headers = progress_headers(_token);


//global leaderboard...
var _url = SUPABASE_URL + "/rest/v1/rpc/get_leaderboard";
leaderboard_load_id = http_request(_url, "POST", _headers, "{}");
ds_map_destroy(_headers);



//user ranking...
if (variable_global_exists("user_id")) {
	var _headers_user = progress_headers(_token);
    var _url_user_rank = SUPABASE_URL + "/rest/v1/rpc/get_user_rank";
    var _payload = json_stringify({ current_user_uuid: global.user_id });
    
    personal_rank_id = http_request(_url_user_rank, "POST", _headers_user, _payload);
	ds_map_destroy(_headers_user);
}

