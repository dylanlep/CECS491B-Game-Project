/// obj_block - Step Event

var mx = mouse_x;
var my = mouse_y;

var over_me = (mx >= x && mx <= x + block_width && my >= y && my <= y + block_height);

is_hovered = over_me && !dragging;
var target_scale = is_hovered ? hover_scale : 1;
display_scale += (target_scale - display_scale) * hover_ease;

if (!dragging && over_me && mouse_check_button_pressed(mb_left)) {
    dragging   = true;
    drag_off_x = mx - x;
    drag_off_y = my - y;

    if (current_slot != -1) {
        obj_game.slot_occupant[current_slot] = noone;
        current_slot = -1;
    }

    depth = -1000;
}

if (dragging) {
    x = mx - drag_off_x;
    y = my - drag_off_y;

    if (mouse_check_button_released(mb_left)) {
        dragging = false;
        depth = 0;

        var snapped = false;
        for (var i = 0; i < obj_game.word_count; i++) {
            var sx = obj_game.slot_x[i];
            var sy = obj_game.slot_y_row[i];
            var sw = obj_game.slot_w[i];
            var over_slot = (mx >= sx && mx <= sx + sw
                           && my >= sy && my <= sy + obj_game.slot_height);

            if (over_slot && obj_game.slot_occupant[i] == noone) {
                x = sx;
                y = sy;
                current_slot = i;
                obj_game.slot_occupant[i] = id;
                snapped = true;
                break;
            }
        }

        if (!snapped) {
            x = home_x;
            y = home_y;
            current_slot = -1;
        }
    }
}