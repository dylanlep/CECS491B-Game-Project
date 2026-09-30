/// scr_google_login
/// "Sign in with Google" through Supabase. Only works in the HTML5 (browser) build.

#macro SUPABASE_URL "https://pwodiopbnnngkfwqpjrg.supabase.co"

/// Sends the player to Google's sign-in page (through Supabase).
function google_login_start() {
    if (os_browser == browser_not_a_browser) {
        show_debug_message("Google login only works in the HTML5 build.");
        return false;
    }
    js_google_login_start(SUPABASE_URL);
    return true;
}

/// Call ONCE when the login room starts.
/// Returns a struct: { status: "none" | "success" | "error", message: "..." }
function google_login_check_return() {
    var _result = { status: "none", message: "" };

    // Not running in a browser? Then there's nothing to check.
    if (os_browser == browser_not_a_browser) return _result;

    // Read everything Supabase put in the address BEFORE cleaning it.
    var _token   = js_google_login_get_param("access_token");
    var _refresh = js_google_login_get_param("refresh_token");
    var _error   = js_google_login_get_param("error_description");
    if (_error == "") _error = js_google_login_get_param("error");

    // Normal visit (player didn't just come back from Google).
    if (_token == "" && _error == "") return _result;

    // Erase the token from the address bar.
    js_google_login_clear_url();

    if (_error != "") {
        _result.status  = "error";
           _result.message = "GOOGLE SIGN-IN FAILED";
   show_debug_message("Google sign-in error: " + _error);
        return _result;
    }

    // Success: save the tokens where the rest of the game can use them.
    global.access_token    = _token;
    global.refresh_token = _refresh;

    _result.status  = "success";
    _result.message = "Signed in with Google!";
    return _result;
}