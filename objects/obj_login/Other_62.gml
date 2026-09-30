/// obj_login - Async HTTP Event

var _id = async_load[? "id"];

if (_id == current_request_id) {
    is_loading = false;
    var _status = async_load[? "status"];
    
    if (_status == 0) { // HTTP Request Successful
        var _result_str = async_load[? "result"];
        var _response_data = json_parse(_result_str);
        
        // Check if Supabase returned an error payload
        if (struct_exists(_response_data, "error") || struct_exists(_response_data, "error_description")) {
            message_color = c_red;
            if (struct_exists(_response_data, "error_description")) {
                message_text = _response_data.error_description;
            } else if (struct_exists(_response_data, "msg")) {
                message_text = _response_data.msg;
            } else {
                message_text = "Authentication failed. Check your inputs.";
            }
        } 
        else {
            // SUCCESSFUL RESPONSE
            if (mode == MODE_LOGIN) {
                message_color = c_green;
                message_text = "Login successful!";
                
                // Store active session tokens
                global.access_token = _response_data.access_token;
                global.user_id = _response_data.user.id;
            } 
            else if (mode == MODE_REGISTER) {
                message_color = c_green;
                message_text = "Account created! You can now log in.";
                
                // Switch mode back to Login
                mode = MODE_LOGIN;
                password_string = "";
                keyboard_string = "";
            }
        }
    } else {
        message_color = c_red;
        message_text = "Network connection error. Try again.";
    }
    
    current_request_id = -1;
}