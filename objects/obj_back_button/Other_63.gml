///obj_back_button - Async Dialog

var _id = async_load[? "id"];
var _status = async_load[? "status"];

if (_id == back_confirm_id) {
    
    if (_status) {
	    room_goto(rm_mode_hub);
    }
    
    back_confirm_id = -1;
}

