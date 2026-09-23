/// @function scr_register_user(username, email, password)
/// @description Validates user inputs, constructs JSON payload, and sends an HTTPS registration request to the backend.
/// @param {string} username The desired username.
/// @param {string} email The user's email address.
/// @param {string} password The chosen password.
/// @returns {struct} Struct containing `success` (bool) and `message` (string).

function scr_register_user(_username, _email, _password) {
    var _response = {
        success: false,
        message: ""
    };


    // CLIENT-SIDE VALIDATION

    // Checks empty fields
    if (_username == "" || _email == "" || _password == "") {
        _response.message = "All fields (username, email, password) are required.";
        return _response;
    }

    // Email format checks
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

    // Password strength checks (Min 8 chars, 1+ number, 1+ special char)
    var _pw_len = string_length(_password);
    if (_pw_len < 8) {
        _response.message = "Password must be at least 8 characters long.";
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


}