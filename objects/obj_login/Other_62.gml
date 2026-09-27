
if (ds_map_find_value(async_load, "id") == supabase_http_request) {
	var status = ds_map_find_value(async_load, "status");
	
	var http_status = ds_map_find_value(async_load, "http_status");
	
	supabase_http_request = -1;
	
	if (status == 0) {
		var response = ds_map_find_value(async_load, "result");
		var response_data = json_decode(response);
		
		if (http_status == 200 || http_status == 201) {
			if (response_data != -1) {
				global.auth_token = ds_map_find_value(response_data, "access_token");
				ds_map_destroy(response_data);
			}
			
			if (mode == MODE_LOGIN) {
				message_text = "Starting game";
				room_goto(rm_lesson);
			} else {
				message_text = "Account created"
				mode = MODE_LOGIN;
			}
		}
		
		
		else {
			var error_text = "Error...";
			if (response_data != -1) {
				if (ds_map_exists(response_data, "msg")) err_msg = ds_map_find_value(response_data, "msg");
	                
					else if (ds_map_exists(response_data, "error_description")) err_msg = ds_map_find_value(response_data, "error_description");
	                ds_map_destroy(response_data);
			}
			message_text = error_text;
		}
		
	
	
	
	
	}
	
	
	
	
}


