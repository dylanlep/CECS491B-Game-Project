function js_google_login_start(supabase_url)
{
    var here = window.location.origin+ window.location.pathname;
    window.location.href =supabase_url + "/auth/v1/authorize?provider=google&prompt=select_account&redirect_to=" + encodeURIComponent(here);
    return 1;

}

function js_google_login_get_param(name)
{
    var hash = new URLSearchParams(window.location.hash.substring(1));
    var query = new URLSearchParams(window.location.search);
    var value = hash.get(name) || query.get(name);
    return value ? value : "";
}

function js_google_login_clear_url()
{
    window.history.replaceState(null, "", window.location.pathname);
    return 1;
}