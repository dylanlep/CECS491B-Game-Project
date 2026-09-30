/// obj_login - Create Event

gpu_set_texfilter(false);

username_string = "";
email_string    = "";
password_string = "";

FIELD_NONE     = -1;
FIELD_USERNAME = 0;
FIELD_EMAIL    = 1;
FIELD_PASSWORD = 2;

active_field = FIELD_NONE;

MODE_LOGIN    = 0;
MODE_REGISTER = 1;
mode = MODE_LOGIN;

show_username = false;
message_text  = "";

field_width  = 140;
field_height = 20;
field_gap    = 6;

username_box_x = (room_width - field_width) / 2;
email_box_x    = (room_width - field_width) / 2;
password_box_x = (room_width - field_width) / 2;

submit_width  = 80;
submit_height = 18;
submit_x1 = (room_width - submit_width) / 2;
submit_x2 = submit_x1 + submit_width;

max_field_length = 24; // emails need a bit more room than the old 16

scr_layout_login_fields();