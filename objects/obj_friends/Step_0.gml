/// obj_friends - Step Event (Friend Hub)

update_layout(); // always first, so Draw never reads stale layout values

if (ignore_clicks > 0) {
    ignore_clicks -= 1;
    exit;
}

var mx = mouse_x;
var my = mouse_y;

var list  = get_list();
var count = array_length(list);

// ---------- Typing in the search bar ----------
if (search_focused) {
    if (string_length(keyboard_string) > max_query_length) {
        keyboard_string = string_copy(keyboard_string, 1, max_query_length);
    }
    query = keyboard_string;
    cursor_blink += 1;

    if (keyboard_check_pressed(vk_enter)) {
        run_search();
        list  = get_list();
        count = array_length(list);
    }
}

// ---------- Esc: leave the search bar first, close the panel second ----------
if (keyboard_check_pressed(vk_escape)) {
    if (search_focused) {
        search_focused = false;
    } else {
        instance_destroy();
        exit;
    }
}

// ---------- Mouse wheel scrolling ----------
var wheel = mouse_wheel_down() - mouse_wheel_up();
if (wheel != 0) {
    scroll = clamp(scroll + wheel, 0, max(0, count - visible_rows));
    confirm_index = -1;
}

// ---------- Clicks ----------
if (mouse_check_button_pressed(mb_left)) {

    var handled = false;

    // --- Tabs ---
    for (var t = 0; t < 3; t++) {
        if (point_in_rectangle(mx, my, tab_x[t], tab_y, tab_x[t] + tab_w, tab_y + tab_h)) {
            handled = true;
            if (tab != t) {
                tab = t;
                scroll = 0;
                confirm_index = -1;
                search_focused = false;
                update_layout();
            }
        }
    }

    // --- Search bar (SEARCH tab only) ---
    if (!handled && tab == 1) {
        if (point_in_rectangle(mx, my, search_x, search_y, search_x + search_w, search_y + search_h)) {
            handled = true;
            search_focused = true;
            keyboard_string = query;
        } else {
            search_focused = false; // clicked somewhere else
        }
    }

    // --- Row buttons ---
    if (!handled) {
        for (var r = 0; r < visible_rows; r++) {
            var idx = scroll + r;
            if (idx >= count) break;

            var item = list[idx];
            var b0   = get_btn(r, 0);
            var b1   = get_btn(r, 1);

            var hit0 = point_in_rectangle(mx, my, b0[0], b0[1], b0[2], b0[3]);
            var hit1 = (tab == 2) && point_in_rectangle(mx, my, b1[0], b1[1], b1[2], b1[3]);

            if (!hit0 && !hit1) continue;
            handled = true;

            if (tab == 0) {
                // FRIENDS: REMOVE, then SURE?
                if (confirm_index == idx) {
                    // TODO (backend teammate): send the real "remove friend" call
                    // using global.friends[idx].id, and only delete locally after
                    // the server confirms it worked.
                    array_delete(global.friends, idx, 1);
                    confirm_index = -1;
                } else {
                    confirm_index = idx;
                }

            } else if (tab == 1) {
                // SEARCH: ADD / ACCEPT (SENT and FRIEND do nothing)
                var st = user_state(item);
                if (st == 0) {
                    // TODO (backend teammate): send the real "send friend request"
                    // call here using item.id.
                    array_push(global.sent_requests, item.id);
                } else if (st == 3) {
                    accept_request(find_by_id(global.friend_requests, item.id));
                }

            } else {
                // REQUESTS: left button = OK (accept), right button = NO (decline)
                if (hit1) accept_request(idx);
                else      decline_request(idx);
            }
            break;
        }
    }

    // --- Close button, or a click outside the panel ---
    if (!handled) {
        var in_panel = point_in_rectangle(mx, my, panel_x, panel_y, panel_x + panel_w, panel_y + panel_h);

        if (point_in_rectangle(mx, my, close_x1, close_y1, close_x2, close_y2) || !in_panel) {
            instance_destroy();
            exit;
        } else {
            confirm_index = -1; // click on empty panel space cancels SURE?
        }
    }
}