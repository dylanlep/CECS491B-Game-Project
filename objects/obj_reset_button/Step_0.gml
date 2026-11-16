/// obj_reset_button - Step

if (!instance_exists(obj_game)) exit;
if (is_frozen()) { hovered = false; exit; }

var _g = instance_find(obj_game, 0);
hovered = (mouse_x >= _g.reset_btn_x1 && mouse_x <= _g.reset_btn_x2
        && mouse_y >= _g.reset_btn_y1 && mouse_y <= _g.reset_btn_y2);

if (hovered && mouse_check_button_pressed(mb_left)) {
    // Put every block back in its bank spot
    with (obj_block) {
        dragging       = false;
        depth          = 0;
        x              = home_x;
        y              = home_y;
        current_slot   = -1;
        drag_from_slot = -1;
    }
    // Empty all slots
    for (var i = 0; i < _g.word_count; i++) _g.slot_occupant[i] = noone;

    _g.feedback_text    = "Blocks reset.";
    _g.feedback_timer   = 60;
    _g.feedback_is_hint = true;

    sfx_play(snd_click);   // SCRUM-52 click sound
}