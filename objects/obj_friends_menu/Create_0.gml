/// obj_friends_menu - Create
// SCRUM-38 / SCRUM-39: friends screen on top of the Mode Hub.
//   ADD      - send a friend request by username        (SCRUM-38)
//   REQUESTS - accept / decline requests, cancel my own (SCRUM-38)
//   FRIENDS  - my friends, REMOVE with a "SURE?" check  (SCRUM-39)
// All server work is in scr_friends.

depth = -10000;
ignore_clicks = 2;          // the click that opened this panel shouldn't press anything

// Forget answers that never arrived (e.g. panel closed while waiting), then load.
friends_init();
global.friends_sync_id   = -1;
global.friends_load_id   = -1;
global.friends_action_id = -1;
global.friends_message   = "";
friends_load();

tab        = 0;             // 0 = ADD, 1 = REQUESTS, 2 = FRIENDS
tab_label  = ["ADD", "REQUESTS", "FRIENDS"];
tab_x      = [0, 0, 0];
tab_w      = [0, 0, 0];
hover_tab  = -1;
confirm_id = -1;            // friend waiting on the "SURE?" click
typed      = "";
keyboard_string = "";

// Panel
px = 8;
py = 8;
pw = room_width  - 16;
ph = room_height - 16;

// Tabs
tab_y = py + 22;
tab_h = 16;

// ADD tab: text box + SEND
box_x = px + 16;
box_y = py + 66;
box_w = pw - 32;
box_h = 16;
send_label = "SEND REQUEST";
send_w = ui_button_width(send_label);
send_h = 16;
send_x = (room_width - send_w) / 2;
send_y = box_y + 24;
hover_send = false;

// REQUESTS / FRIENDS lists
list_y    = tab_y + tab_h + 8;
row_h     = 16;
row_step  = 20;
max_rows  = 7;
rows      = [];             // what the current tab shows
btns      = [];             // buttons on the rows: { x, y, w, label, act, id }
hover_btn = -1;

// CLOSE
close_label = "CLOSE";
close_w = ui_button_width(close_label);
close_h = 16;
close_x = (room_width - close_w) / 2;
close_y = py + ph - close_h - 6;
hover_close = false;

// Message line (answers from the server)
msg_y = close_y - 10;