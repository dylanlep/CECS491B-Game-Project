///obj_back_button - Async Dialog

var _id = async_load[? "id"];
var _status = async_load[? "status"];

if (_id == back_confirm_id) {
    
    if (_status) {
		//moved so user confirms choice before executing...
        // SCRUM-29: bank this lesson's XP as coins (1 XP = 1 coin), then save
	    if (instance_exists(obj_game)) {
	        var _earned = 0;
	        for (var i = 0; i < array_length(obj_game.language_scores); i++) {
	            _earned += obj_game.language_scores[i];
	        }
	        progress_earn(_earned);
	    }

	    room_goto(rm_mode_hub);
    }
    
    back_confirm_id = -1;
}

