/// obj_logout_button - Async HTTP
// Runs whenever ANY web request in the game gets an answer.

if (async_load[? "id"] != logout_request_id) exit;   // not our answer, ignore it
if (async_load[? "status"] == 1) exit;               // still downloading, wait

alarm[0] = -1;            // answer arrived in time, cancel the 3-second timer
logout_request_id = -1;

var _status = async_load[? "status"];       // below 0 = couldn't connect at all
var _http   = async_load[? "http_status"];  // Supabase's answer code

if (_status == 0 && ((_http >= 200 && _http < 300) || _http == 401 || _http == 403)) {
    // Session ended on Supabase (or was already invalid).
    logout_finish("YOU HAVE BEEN LOGGED OUT");
} else {
    // No internet or a server problem: log out on this device anyway.
    logout_finish("LOGOUT COMPLETED LOCALLY");
}