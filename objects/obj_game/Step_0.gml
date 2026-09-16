/// obj_game - Step Event

if (feedback_timer > 0) {
    feedback_timer -= 1;
    if (feedback_timer <= 0) feedback_text = "";
} 

if (mouse_check_button_pressed(mb_left)) {

    // --- Language buttons ---
    for (var i = 0; i < lesson_count; i++) {
        var bx1 = lang_button_x[i];
        var by1 = lang_button_y;
        var bx2 = bx1 + lang_button_width;
        var by2 = by1 + lang_button_height;

        if (mouse_x >= bx1 && mouse_x <= bx2 && mouse_y >= by1 && mouse_y <= by2) {
            current_lesson = i;
            scr_setup_lesson();
        }
    }

    // --- Check button ---
    var cx1 = room_width/2 - 70;
    var cy1 = 560;
    var cx2 = room_width/2 + 70;
    var cy2 = 605;

    if (mouse_x >= cx1 && mouse_x <= cx2 && mouse_y >= cy1 && mouse_y <= cy2) {
        var all_filled  = true;
        var all_correct = true;

        for (var i = 0; i < word_count; i++) {
            if (slot_occupant[i] == noone) {
                all_filled = false;
            } else if (slot_occupant[i].correct_index != i) {
                all_correct = false;
            }
        }

        if (!all_filled) {
            feedback_text = "Fill in all the blocks first!";
        } else if (all_correct) {
            feedback_text = "Correct! Great job!";
        } else {
            feedback_text = "Not quite — try again.";
        }
        feedback_timer = 90; // ~1.5 sec at 60fps
    }
}