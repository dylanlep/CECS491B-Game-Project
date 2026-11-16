/// obj_block - Step Event

if (instance_exists(obj_game) && obj_game.account_open) exit;

var mx = mouse_x;
var my = mouse_y;

var over_me = (mx >= x && mx <= x + block_width && my >= y && my <= y + block_height);

is_hovered = over_me && !dragging;
var target_scale = is_hovered ? hover_scale : 1;
display_scale += (target_scale - display_scale) * hover_ease;

// --- Pick up ---
if (!dragging && over_me && mouse_check_button_pressed(mb_left)) {
    dragging   = true;
    drag_off_x = mx - x;
    drag_off_y = my - y;

    // SCRUM-58: remember which slot we came from (-1 = from the bank),
    // so a block we bump out of a slot can move there.
    drag_from_slot = current_slot;

    if (current_slot != -1) {
        obj_game.slot_occupant[current_slot] = noone;
        current_slot = -1;
    }

    depth = -1000;
}

// --- Drag and drop ---
if (dragging) {
    x = mx - drag_off_x;
    y = my - drag_off_y;

    if (mouse_check_button_released(mb_left)) {
        dragging = false;
        depth = 0;

        // Which slot (if any) is under the mouse?
        var _target = -1;
        for (var i = 0; i < obj_game.word_count; i++) {
            var sx = obj_game.slot_x[i];
            var sy = obj_game.slot_y_row[i];
            var sw = obj_game.slot_w[i];
            if (mx >= sx && mx <= sx + sw && my >= sy && my <= sy + obj_game.slot_height) {
                _target = i;
                break;
            }
        }

        if (_target == -1) {
            // Dropped outside every slot -> back to the bank
            x = home_x;
            y = home_y;
            current_slot = -1;
        } else {
            // SCRUM-58: slot already taken -> swap instead of bouncing back
            var _other = obj_game.slot_occupant[_target];
            if (_other != noone && instance_exists(_other)) {
                if (drag_from_slot != -1 && obj_game.slot_occupant[drag_from_slot] == noone) {
                    // We came from a slot: the other block takes our old slot
                    _other.x            = obj_game.slot_x[drag_from_slot];
                    _other.y            = obj_game.slot_y_row[drag_from_slot];
                    _other.current_slot = drag_from_slot;
                    obj_game.slot_occupant[drag_from_slot] = _other;
                } else {
                    // We came from the bank: the other block goes back to its bank spot
                    _other.x            = _other.home_x;
                    _other.y            = _other.home_y;
                    _other.current_slot = -1;
                }
            }

            // Take the slot
            x = obj_game.slot_x[_target];
            y = obj_game.slot_y_row[_target];
            current_slot = _target;
            obj_game.slot_occupant[_target] = id;
        }

        drag_from_slot = -1;
    }
}