var _request_id = async_load[? "id"];
if (_request_id != account_request_id) exit;

var _request_status = async_load[? "status"];
if (_request_status == 1) exit; // Request is still downloading.
if (_request_status < 0) {
    account_message = "Could not connect to the authentication service.";
    account_busy = false;
    account_request_id = -1;
    exit;
}

var _http_status = async_load[? "http_status"];
var _result = async_load[? "result"];

if (_http_status >= 200 && _http_status < 300) {
    account_message = account_pending_email_change
        ? "Check email to confirm the email change."
        : "Password updated successfully.";
    account_email_input = "";
    account_password_input = "";
    account_active_field = 0;
} else {
    var _error = json_decode(_result);
    if (ds_map_exists(_error, "msg")) {
        account_message = ds_map_find_value(_error, "msg");
    } else if (ds_map_exists(_error, "message")) {
        account_message = ds_map_find_value(_error, "message");
    } else {
        account_message = "Could not save changes (HTTP " + string(_http_status) + ").";
    }
    ds_map_destroy(_error);
}

account_busy = false;
account_request_id = -1;
account_pending_email_change = false;
