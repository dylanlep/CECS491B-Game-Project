//obj_leaderboard - Async HTTP

var _id = async_load[? "id"];

//global leaderboard
if (_id == leaderboard_load_id) {
	if (async_load[? "status"] == 1) exit;
	var _http_status = async_load[? "http_status"];
	
	if (_http_status >= 200 && _http_status < 300) {
		var _data = json_parse(async_load[? "result"]);
		
		if (is_array(_data)) {
			leaderboard_list = _data
			loading_status = (array_length(leaderboard_list) == 0) ? "no entries found..." : "";
		}
		
	} else {
		loading_status = "Error: HTTP " + string(_http_status);
	}
	exit;
}

//user rank
if (_id == personal_rank_id) {
    if (async_load[? "status"] == 1) exit;
    
	var _http_status = async_load[? "http_status"];
    
    if (_http_status >= 200 && _http_status < 300) {
        var _data = json_parse(async_load[? "result"]);
		
        if (is_array(_data) && array_length(_data) > 0) {
            user_rank_struct = _data[0];
			
        } else {
			user_rank_struct = {
                    my_rank: 0,
                    username: variable_global_exists("username") ? global.username : "You",
                    xp: 0
                };
		}
    }
    exit;
}

