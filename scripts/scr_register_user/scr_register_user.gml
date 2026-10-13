/// @function scr_register_user(username, email, password)
/// @description Validates user inputs, constructs JSON payload, and sends an HTTPS registration request directly to Supabase Auth.
/// @param {string} username The desired username.
/// @param {string} email The user's email address.
/// @param {string} password The chosen password.
/// @returns {struct} Struct containing `success` (bool), `async_id` (real), `timestamp` (real), and `message` (string).

function scr_register_user(_username, _email, _password) {
    var _response = {
        success: false,
        async_id: -1,
        timestamp: current_time,
        message: ""
    };


    // INPUT SANITIZATION & EMPTY CHECKS
	
    _username = string_trim(_username);
    _email = string_trim(_email);

    if (_username == "" || _email == "" || _password == "") {
        _response.message = "All fields (username, email, password) are required.";
        return _response;
    }


    // USERNAME VALIDATION

    if (string_length(_username) < 3 || string_length(_username) > 20) {
        _response.message = "Username must be between 3 and 20 characters long.";
        return _response;
    }

    if (string_pos(" ", _username) > 0) {
        _response.message = "Username cannot contain spaces.";
        return _response;
    }


    // EMAIL FORMAT VALIDATION

    if (string_pos(" ", _email) > 0) {
        _response.message = "Email address cannot contain spaces.";
        return _response;
    }

    var _at_pos = string_pos("@", _email);
    var _last_dot_pos = string_last_pos(".", _email);

    if (_at_pos <= 1 || _last_dot_pos <= _at_pos + 1 || _last_dot_pos == string_length(_email)) {
        _response.message = "Please enter a valid email address.";
        return _response;
    }


    // PASSWORD STRENGTH VALIDATION

    var _pw_len = string_length(_password);
    
    if (_pw_len < 8) {
        _response.message = "Password must be at least 8 characters long.";
        return _response;
    }

    if (_pw_len > 128) {
        _response.message = "Password exceeds the maximum length limit.";
        return _response;
    }

    var _has_number = false;
    var _has_special = false;
    var _special_chars = "!@#$%^&*()_+-=[]{}|;:'\",.<>/?\\~`";

    for (var i = 1; i <= _pw_len; i++) {
        var _char = string_char_at(_password, i);
        var _ord = ord(_char);

        if (_ord >= 48 && _ord <= 57) {
            _has_number = true;
        } else if (string_pos(_char, _special_chars) > 0) {
            _has_special = true;
        }

        if (_has_number && _has_special) break;
    }

    if (!_has_number) {
        _response.message = "Password must contain at least one number.";
        return _response;
    }

    if (!_has_special) {
        _response.message = "Password must contain at least one special character.";
        return _response;
    }


    // SUPABASE REST API CONFIGURATION 

    var _supabase_url = "https://pwodiopbnnngkfwqpjrg.supabase.co";
    var _anon_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB3b2Rpb3Bibm5uZ2tmd3FwanJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTAxNzc0MTQsImV4cCI6MjEwNTc1MzQxNH0.jIDwM76MXF36zZG8S2T79Pu4B9fCG_LeaXfsA9W7pXQ";
    
    var _api_url = _supabase_url + "/auth/v1/signup";

    // Build Payload Structure for Supabase Auth
    var _payload_map = ds_map_create();
    ds_map_add(_payload_map, "email", _email);
    ds_map_add(_payload_map, "password", _password);
    
    // Pass custom metadata (username) inside the user_metadata object
    var _user_data_map = ds_map_create();
    ds_map_add(_user_data_map, "username", _username);
    ds_map_add_map(_payload_map, "data", _user_data_map);

    var _json_body = json_encode(_payload_map);
    ds_map_destroy(_payload_map); // Free memory immediately

    // Build Headers Required by Supabase REST API
    var _headers_map = ds_map_create();
    ds_map_add(_headers_map, "Content-Type", "application/json");
    ds_map_add(_headers_map, "apikey", _anon_key);

    // Execute Asynchronous HTTPS POST Request
    var _request_id = http_request(_api_url, "POST", _headers_map, _json_body);
    ds_map_destroy(_headers_map); // Free memory immediately

    _response.success = true;
    _response.async_id = _request_id;
    _response.message = "Registration request sent to Supabase.";

    return _response;
}