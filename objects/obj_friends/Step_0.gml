/// obj_friends - Step Event

if (ignore_clicks > 0) {
    ignore_clicks -= 1;
    exit;
}

var mx = mouse_x;
var my = mouse_y;

var friend_count = array_length(global.friends);
var max_scroll   = max(0, friend_count - visible_rows);

// ---------- Esc closes ----------
if (keyboard_check_pressed(vk_escape)) {
    instance_destroy();
    exit;
}

// ---------- Mouse wheel scrolling ----------
var wheel = mouse_wheel_down() - mouse_wheel_up();
if (wheel != 0) {
    scroll = clamp(scroll + wheel, 0, max_scroll);
    confirm_index = -1;
}

// ---------- Clicks ----------
if (mouse_check_button_pressed(mb_left)) {

    var handled = false;

    for (var r = 0; r < visible_rows; r++) {
        var idx = scroll + r;
        if (idx >= friend_count) break;

        var ry  = list_y + r * (row_height + row_gap);
        var bx1 = list_x + list_w - 4 - remove_w;
        var by1 = ry + 3;
        var bx2 = bx1 + remove_w;
        var by2 = ry + row_height - 3;

        if (point_in_rectangle(mx, my, bx1, by1, bx2, by2)) {
            handled = true;

            if (confirm_index == idx) {
                // TODO (backend teammate): send the real "remove friend"
                // request here using global.friends[idx].id, and only delete
                // from the local array once the server confirms it worked.
                array_delete(global.friends, idx, 1);
                confirm_index = -1;
                scroll = clamp(scroll, 0, max(0, array_length(global.friends) - visible_rows));
            } else {
                confirm_index = idx;
            }
            break;
        }
    }

    if (!handled) {
        var in_panel = point_in_rectangle(mx, my, panel_x, panel_y, panel_x + panel_w, panel_y + panel_h);

        if (point_in_rectangle(mx, my, close_x1, close_y1, close_x2, close_y2) || !in_panel) {
            instance_destroy(); // CLOSE button, or a click outside the panel
            exit;
        } else {
            confirm_index = -1; // click on empty panel space cancels SURE?
        }
    }
}