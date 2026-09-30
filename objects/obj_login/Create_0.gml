/// obj_login - Create Event

// ---------- Field state ----------
email_string = "";
username_string = "";
password_string = "";

FIELD_NONE     = -1;
FIELD_EMAIL = 0;
FIELD_USERNAME = 1; 
FIELD_PASSWORD = 2;

active_field = FIELD_NONE;

MODE_LOGIN    = 0;
MODE_REGISTER = 1;
mode = MODE_LOGIN;

message_text = "";
message_color = c_red;

// ---------- Network Tracking ----------
current_request_id = -1;
is_loading = false;

// ---------- Layout ----------
field_width  = 340;
field_height = 45;

email_box_x = room_width/2 - field_width/2;
email_box_y = 220;

username_box_x = room_width/2 - field_width/2;
username_box_y = 280;

password_box_x = room_width/2 - field_width/2;
password_box_y = 340;

submit_x1 = room_width/2 - 90;
submit_y1 = 410;
submit_x2 = room_width/2 + 90;
submit_y2 = 455;

max_field_length = 64;