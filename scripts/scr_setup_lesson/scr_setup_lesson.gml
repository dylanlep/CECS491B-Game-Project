/// scr_setup_lesson
/// Wipes existing chips and spawns a shuffled lesson for obj_game.current_lesson
///
/// NOTE: current GameMaker requires script assets to be wrapped in a named
/// function like this — loose top-level code isn't reliably bound to the
/// calling instance's self.

function scr_setup_lesson() {

    with (obj_block) {
        instance_destroy();
    }

    correct_answer = lesson_tokens[current_lesson];
    word_count = array_length(correct_answer);

    // --- Answer slot layout ---
    // slot_width shrinks to fit however many tokens this lesson has, so the
    // row of slots never runs off the edges of the room. 200 is just a cap
    // so slots don't get silly-wide on a short 3-4 token lesson.
    var margin        = 40;
    var max_slot_width = 200;

    slot_height  = 70;
    slot_spacing = 12;
    slot_y       = 260;

    var raw_width = floor((room_width - margin - (word_count - 1) * slot_spacing) / word_count);
    slot_width = min(max_slot_width, raw_width);

    var total_w = word_count * (slot_width + slot_spacing) - slot_spacing;
    var start_x = (room_width - total_w) / 2;

    // slot_center_x[i] / slot_center_y are the fixed anchor points each slot
    // keeps forever. Both the placeholder outline (when empty) and whatever
    // chip snaps in (when full) are centered on these same points, so nothing
    // ever looks off-center regardless of how wide the chip is.
    slot_center_y = slot_y + slot_height / 2;

    for (var i = 0; i < word_count; i++) {
        slot_x[i] = start_x + i * (slot_width + slot_spacing);
        slot_center_x[i] = slot_x[i] + slot_width / 2;
        slot_occupant[i] = noone;
    }

    // --- Shuffle token order for the bank ---
    var order[0];
    for (var i = 0; i < word_count; i++) {
        order[i] = i;
    }
    for (var i = word_count - 1; i > 0; i--) {
        var j = irandom(i);
        var tmp = order[i];
        order[i] = order[j];
        order[j] = tmp;
    }

    // --- Spawn a chip per token ---
    var bank_y = 460;
    var bx = 60;

    for (var i = 0; i < word_count; i++) {
        var idx  = order[i];
        var word = correct_answer[idx];
        var w    = max(90, string_width(word) + 30);

        var inst = instance_create_layer(bx, bank_y, "Instances", obj_block);
        inst.word_text    = word;
        inst.correct_index = idx;
        inst.block_width  = w;
        inst.block_height = 70;
        inst.home_x       = bx;
        inst.home_y       = bank_y;
        inst.current_slot = -1;

        bx += w + 20;
    }

    feedback_text  = "";
    feedback_timer = 0;
}