//obj_controller - Async-HTTP

var _request_id = async_load[? "id"];
if (_request_id != global.pending_auth_request_id) exit;

var _request_status = async_load[? "status"];

if (_request_status == 1) exit; 
if (_request_status < 0) {
    if (instance_exists(obj_login)) {
		obj_login.message_text = "Connection failed...";
		obj_login.show_ui = true;
	}
    exit;
}


var _http_status = async_load[? "http_status"];
var _result = async_load[? "result"];
var _data = json_decode(_result);


if (global.pending_auth_mode == "auto_login") {
    if (_http_status >= 200 && _http_status < 300) {
        ini_open("saved_login.ini");
        global.supabase_access_token = ini_read_string("Data", "token", "");
        ini_close();
        
        if (instance_exists(obj_login)) {
			obj_login.message_text = "Welcome";
		}
		
        ds_map_destroy(_data);
        room_goto(rm_mode_hub);
		
		
    } else {
        if (file_exists("saved_login.ini")) {
            file_delete("saved_login.ini");
        }
		
        if (instance_exists(obj_login)) {
			obj_login.message_text = "session expired... please log in again";
	        obj_login.show_ui = true;
		}
		ds_map_destroy(_data);
		
    }
    exit;
}

