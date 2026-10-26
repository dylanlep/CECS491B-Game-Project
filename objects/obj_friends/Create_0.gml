/// obj_friends - Create Event (Friend Hub)

depth = -10000; // draw above everything, including a chip being dragged

// The click that opened this panel can still be "pressed" on the first frame.
// Ignore clicks for the first couple of frames so it can't hit something below.
ignore_clicks = 2;

// =====================================================================
// PLACEHOLDER DATA (globals, so changes survive closing/reopening)
// TODO (backend teammates): replace each of these with real Supabase data.
// Every user is a struct shaped { id, name, xp }.
// =====================================================================

// Current friends
if (!variable_global_exists("friends")) {
    global.friends = [
        { id: "placeholder-1", name: "PixelPete", xp: 120 },
        { id: "placeholder-2", name: "CodeCat",   xp: 85  },
        { id: "placeholder-3", name: "ByteMe",     xp: 240 },
        { id: "placeholder-4", name: "NullPtr",    xp: 15  },
        { id: "placeholder-5", name: "LoopLord",   xp: 330 },
        { id: "placeholder-6", name: "SyntaxSam",  xp: 60  },
        { id: "placeholder-7", name: "BugHunter",  xp: 410 },
        { id: "placeholder-8", name: "StackOver",  xp: 175 }
    ];
}

// Incoming friend requests (people who asked to be YOUR friend)
if (!variable_global_exists("friend_requests")) {
    global.friend_requests = [
        { id: "user-101", name: "ScriptKid", xp: 95  },
        { id: "user-102", name: "DebugDuck", xp: 150 },
        { id: "user-103", name: "BitFlip",   xp: 30  }
    ];
}

// Ids of users YOU already sent a request to (shows "SENT" in search)
if (!variable_global_exists("sent_requests")) {
    global.sent_requests = [];
}

// Everyone searchable. A real backend would search the server instead.
if (!variable_global_exists("all_users")) {
    global.all_users = [
        { id: "placeholder-1", name: "PixelPete",     xp: 120 },
        { id: "placeholder-2", name: "CodeCat",       xp: 85  },
        { id: "placeholder-3", name: "ByteMe",        xp: 240 },
        { id: "placeholder-4", name: "NullPtr",       xp: 15  },
        { id: "placeholder-5", name: "LoopLord",      xp: 330 },
        { id: "placeholder-6", name: "SyntaxSam",     xp: 60  },
        { id: "placeholder-7", name: "BugHunter",     xp: 410 },
        { id: "placeholder-8", name: "StackOver",     xp: 175 },
        { id: "user-101",      name: "ScriptKid",     xp: 95  },
        { id: "user-102",      name: "DebugDuck",     xp: 150 },
        { id: "user-103",      name: "BitFlip",       xp: 30  },
        { id: "user-104",      name: "HexHero",       xp: 205 },
        { id: "user-105",      name: "ArrayAndy",     xp: 70  },
        { id: "user-106",      name: "CacheMe",       xp: 310 },
        { id: "user-107",      name: "RecursionRita", xp: 480 },
        { id: "user-108",      name: "TernaryTim",    xp: 55  }
    ];
}

// So you never show up in your own search results
my_name = (variable_global_exists("username") && global.username != "") ? global.username : "Player_One";

// =====================================================================
// STATE
// =====================================================================
tab           = 0;     // 0 = FRIENDS, 1 = SEARCH, 2 = REQUESTS
confirm_index = -1;    // friends tab: row waiting on its second "SURE?" click
scroll        = 0;     // index of the first visible row

query            = "";
search_focused   = false;
searched         = false;  // has Enter been pressed at least once
search_results   = [];
max_query_length = 16;
cursor_blink     = 0;

// =====================================================================
// LAYOUT (computed from the room, not hardcoded)
// =====================================================================
panel_w = min(room_width  - 16, 236);
panel_h = min(room_height - 16, 224);
panel_x = (room_width  - panel_w) / 2;
panel_y = (room_height - panel_h) / 2;

row_height = 22;
row_gap    = 4;
remove_w   = 56;   // width of the single big button (REMOVE / ADD / FRIEND...)
small_w    = 22;   // width of the two small request buttons (OK / NO)

list_x = panel_x + 8;
list_w = panel_w - 16;

// Tabs
tab_h   = 14;
tab_gap = 4;
tab_y   = panel_y + 6;
tab_w   = floor((list_w - tab_gap * 2) / 3);
for (var i = 0; i < 3; i++) {
    tab_x[i] = list_x + i * (tab_w + tab_gap);
}
tab_label = ["FRIENDS", "SEARCH", "REQ"]; // REQ gets its count added when drawn

content_y = tab_y + tab_h + 6;

// Search bar (only shown on the SEARCH tab)
search_h = 16;
search_x = list_x;
search_y = content_y;
search_w = list_w;

// Close button
close_w  = 80;
close_h  = 18;
close_x1 = (room_width - close_w) / 2;
close_y1 = panel_y + panel_h - close_h - 8;
close_x2 = close_x1 + close_w;
close_y2 = close_y1 + close_h;

// These two depend on the active tab. update_layout() keeps them current.
list_top     = content_y;
visible_rows = 1;

// =====================================================================
// HELPER METHODS
// =====================================================================

// Index of a user id inside an array of user structs, or -1
find_by_id = function(_list, _id) {
    for (var i = 0; i < array_length(_list); i++) {
        if (_list[i].id == _id) return i;
    }
    return -1;
};

// Is this id inside a plain array of ids?
id_in_ids = function(_ids, _id) {
    for (var i = 0; i < array_length(_ids); i++) {
        if (_ids[i] == _id) return true;
    }
    return false;
};

// Which list the active tab is showing
get_list = function() {
    if (tab == 0) return global.friends;
    if (tab == 1) return search_results;
    return global.friend_requests;
};

// Relationship to a searched user: 0 = can add, 1 = already friends,
// 2 = request sent, 3 = they already sent YOU a request
user_state = function(_u) {
    if (find_by_id(global.friends, _u.id) != -1) return 1;
    if (id_in_ids(global.sent_requests, _u.id)) return 2;
    if (find_by_id(global.friend_requests, _u.id) != -1) return 3;
    return 0;
};

// Run the search. Empty query lists everyone (handy for browsing).
run_search = function() {
    // TODO (backend teammate): replace this loop with a real search request
    // (send "query", get back an array of { id, name, xp }). http_request()
    // is async, so fill search_results from the Async - HTTP event instead.
    search_results = [];
    var q = string_lower(string_trim(query));
    for (var i = 0; i < array_length(global.all_users); i++) {
        var u = global.all_users[i];
        if (u.name == my_name) continue;
        if (q == "" || string_pos(q, string_lower(u.name)) > 0) {
            array_push(search_results, u);
        }
    }
    searched = true;
    scroll   = 0;
};

// Accept the request at index _i: they become a friend
accept_request = function(_i) {
    if (_i < 0) return;
    // TODO (backend teammate): send the real "accept request" call here
    // and only change the local lists after the server confirms.
    var r = global.friend_requests[_i];
    array_push(global.friends, { id: r.id, name: r.name, xp: r.xp });
    array_delete(global.friend_requests, _i, 1);
};

// Decline the request at index _i
decline_request = function(_i) {
    if (_i < 0) return;
    // TODO (backend teammate): send the real "decline request" call here.
    array_delete(global.friend_requests, _i, 1);
};

// Rectangle of a row's button: [x1, y1, x2, y2].
// _slot 0 = the main (right-most) button, _slot 1 = the one to its left (requests tab only)
get_btn = function(_r, _slot) {
    var ry = list_top + _r * (row_height + row_gap);
    var w  = (tab == 2) ? small_w : remove_w;
    var x2 = list_x + list_w - 4;
    if (_slot == 1) x2 -= (small_w + 4);
    return [x2 - w, ry + 3, x2, ry + row_height - 3];
};

// Draw one button. Brightens on hover when enabled.
draw_btn = function(_b, _label, _color, _text_color, _enabled) {
    var c = _color;
    if (_enabled && point_in_rectangle(mouse_x, mouse_y, _b[0], _b[1], _b[2], _b[3])) {
        c = merge_color(_color, c_white, 0.25);
    }
    draw_set_color(c_black);
    draw_rectangle(_b[0], _b[1], _b[2], _b[3], false);
    draw_set_color(c);
    draw_rectangle(_b[0] + 1, _b[1] + 1, _b[2] - 1, _b[3] - 1, false);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(_text_color);
    draw_text((_b[0] + _b[2]) / 2, (_b[1] + _b[3]) / 2, _label);
};

// Recompute where the list starts and how many rows fit (depends on the tab)
update_layout = function() {
    list_top = content_y + ((tab == 1) ? (search_h + 6) : 0);
    visible_rows = max(1, floor((close_y1 - 6 - list_top + row_gap) / (row_height + row_gap)));
    var n = array_length(get_list());
    scroll = clamp(scroll, 0, max(0, n - visible_rows));
};

update_layout();