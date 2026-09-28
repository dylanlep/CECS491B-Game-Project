/// @function scr_login_user(email, password)
/// @description Authenticates an existing user via Supabase Auth REST API.
/// @param {string} email The user's registered email address.
/// @param {string} password The user's account password.
/// @returns {struct} Struct containing `success` (bool), `async_id` (real), `timestamp` (real), and `message` (string).

function scr_login_user(_email, _password) {
    var _response = {
        success: false,
        async_id: -1,
        timestamp: current_time,
        message: ""
    };

    // INPUT SANITIZATION & CHECKS
    _email = string_trim(_email);

    if (_email == "" || _password == "") {
        _response.message = "Email and password are required.";
        return _response;
    }

    // Basic Email Format Check
    var _at_pos = string_pos("@", _email);
    var _last_dot_pos = string_last_pos(".", _email);

    if (_at_pos <= 1 || _last_dot_pos <= _at_pos + 1 || _last_dot_pos == string_length(_email)) {
        _response.message = "Please enter a valid email address.";
        return _response;
    }


    // SUPABASE AUTH REST API ENDPOINT
    var _supabase_url = "https://pwodiopbnnngkfwqpjrg.supabase.co"; 
    var _anon_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB3b2Rpb3Bibm5uZ2tmd3FwanJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTAxNzc0MTQsImV4cCI6MjEwNTc1MzQxNH0.jIDwM76MXF36zZG8S2T79Pu4B9fCG_LeaXfsA9W7pXQ";

    // Supabase Password Grant Token Endpoint
    var _api_url = _supabase_url + "/auth/v1/token?grant_type=password";

    // Build Payload
    var _payload_map = ds_map_create();
    ds_map_add(_payload_map, "email", _email);
    ds_map_add(_payload_map, "password", _password);

    var _json_body = json_encode(_payload_map);
    ds_map_destroy(_payload_map);

    // Build Headers
    var _headers_map = ds_map_create();
    ds_map_add(_headers_map, "Content-Type", "application/json");
    ds_map_add(_headers_map, "apikey", _anon_key);

    // Send Asynchronous POST Request
    var _request_id = http_request(_api_url, "POST", _headers_map, _json_body);
    ds_map_destroy(_headers_map);

    _response.success = true;
    _response.async_id = _request_id;
    _response.message = "Authenticating with Supabase...";

    return _response;
}