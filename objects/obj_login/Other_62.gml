/// obj_login - Async HTTP Event

var _id = async_load[? "id"];
if (_id != current_request_id) exit; // Ignore old or unrelated requests

is_loading = false;
var _status = async_load[? "status"];

if (_status == 0) { // HTTP Request Completed Successfully
    var _result_str = async_load[? "result"];
    
    if (_result_str == undefined || _result_str == "") {
        exit; // Empty payload, nothing to parse yet
    }
    
    try {
        var _response_data = json_parse(_result_str);
        
        if (is_struct(_response_data)) {
            
            // 1. SUCCESS: Login path (Access token returned)
            if (struct_exists(_response_data, "access_token")) {
                global.access_token = _response_data.access_token;
                
                if (struct_exists(_response_data, "user") && struct_exists(_response_data.user, "id")) {
                    global.user_id = _response_data.user.id;
                }
                
                message_color = c_green;
                message_text = "Login successful!";
            } 
            // 2. SUCCESS: Registration path
            else if (mode == MODE_REGISTER && (struct_exists(_response_data, "id") || struct_exists(_response_data, "user"))) {
                message_color = c_green;
                message_text = "Account created! You can now log in.";
                mode = MODE_LOGIN;
            }
            // 3. ERROR PATHS (Supabase duplicate email or auth error payloads)
            else {
                message_color = c_red;

                if (struct_exists(_response_data, "msg")) {
                    message_text = _response_data.msg;
                } 
                else if (struct_exists(_response_data, "error_description")) {
                    message_text = _response_data.error_description;
                } 
                else if (struct_exists(_response_data, "message")) {
                    message_text = _response_data.message;
                } 
                else if (struct_exists(_response_data, "error")) {
                    message_text = string(_response_data.error);
                } 
                else {
                    message_text = (mode == MODE_REGISTER) ? "Registration failed. Try a different email." : "Invalid credentials.";
                }
            }
        } else {
            message_color = c_red;
            message_text = "Invalid response format from server.";
        }
    } catch (_exception) {
        message_color = c_red;
        message_text = "Failed to parse server response.";
    }
} else {
    message_color = c_red;
    message_text = "Network error. Please try again.";
}

current_request_id = -1;