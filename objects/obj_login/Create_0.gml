/// obj_login - Create Event

// ---------- Field state ----------
username_string = "";
password_string = "";

FIELD_NONE     = -1;
FIELD_USERNAME = 0;
FIELD_PASSWORD = 1;

active_field = FIELD_NONE;

MODE_LOGIN    = 0;
MODE_REGISTER = 1;
mode = MODE_LOGIN;

message_text = "";

// ---------- Layout ----------
field_width  = 340;
field_height = 50;

username_box_x = room_width/2 - field_width/2;
username_box_y = 260;

password_box_x = room_width/2 - field_width/2;
password_box_y = 330;

submit_x1 = room_width/2 - 90;
submit_y1 = 410;
submit_x2 = room_width/2 + 90;
submit_y2 = 455;

max_field_length = 32;

// ----- Supabase Connection -----
var base_url = "https://pwodiopbnnngkfwqpjrg.supabase.co";

login_url = base_url + "/auth/v1/token?grant_type=password";
register_url = base_url + "/auth/v1/signup";

supabase_publishable_key = "sb_publishable_hri5mZ3bBR-n9bHt8wC_dQ_HRE5CaEU";

supabase_http_request = -1;

//-----wip menu focus----
global.menu_focus = "login";
