//obj_controller - Create

ini_open("saved_login.ini");

if (ini_key_exists("Data", "token")) {
    var _saved_token = ini_read_string("Data", "token", "");
    ini_close();

    
    if (instance_exists(obj_login)) {
        obj_login.message_text = "Authenticating saved session...";
    }
	message_text = "Authenticating saved session...";
	
	
    
    var _headers = ds_map_create();
    ds_map_add(_headers, "Authorization", "Bearer " + _saved_token);
    ds_map_add(_headers, "apikey", SUPABASE_PUBLISHABLE_KEY); 
    var _url = SUPABASE_URL + "/auth/v1/user"; 
    
    global.pending_auth_request_id = http_request(_url, "GET", _headers, "");
    global.pending_auth_mode = "auto_login"; 
	
    
    ds_map_destroy(_headers);
	
} else {
    ini_close();
    if (instance_exists(obj_login)) {
        obj_login.message_text = "enter your login credentials";
		obj_login.show_ui = true;
    }
}
