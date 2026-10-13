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

	draw_set_font(fnt_pixel); // needed here so string_width() below is accurate

	correct_answer = lesson_tokens[current_lesson];
	word_count = array_length(correct_answer);

	// =====================================================================
	// PART 1 — lay out the answer slots (always in correct order, empty)
	// =====================================================================

	var sx = side_margin;
	var sy = slot_area_y_start;

	for (var i = 0; i < word_count; i++) {
	    var w = string_width(correct_answer[i]) + chip_padding;

	    if (sx + w > room_width - side_margin) {
	        sx = side_margin;
	        sy += row_height + row_spacing;
	    }

	    slot_x[i]        = sx;
	    slot_y_row[i]     = sy;
	    slot_w[i]         = w;
	    slot_occupant[i]  = noone;

	    sx += w + chip_spacing;
	}

	slot_height = row_height; // every slot/chip shares the same height
	var slot_area_bottom = sy + row_height;

	// =====================================================================
	// PART 2 — shuffle the bank order, then lay out bank chips (wrapping)
	// =====================================================================

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

	var bank_y_start = slot_area_bottom + 8;
	var bx = side_margin;
	var by = bank_y_start;

	for (var i = 0; i < word_count; i++) {
	    var idx  = order[i];
	    var word = correct_answer[idx];
	    var w    = string_width(word) + chip_padding;

	    if (bx + w > room_width - side_margin) {
	        bx = side_margin;
	        by += row_height + row_spacing;
	    }

	    var inst = instance_create_layer(bx, by, "Instances", obj_block);
	    inst.word_text      = word;
	    inst.correct_index  = idx;
	    inst.block_width    = w;
	    inst.block_height   = row_height;
	    inst.home_x         = bx;
	    inst.home_y         = by;
	    inst.current_slot   = -1;
	    inst.token_category = scr_classify_token(word);
	    inst.base_color     = scr_get_token_color(inst.token_category);

	    bx += w + chip_spacing;
	}

	var bank_area_bottom = by + row_height;

	// =====================================================================
	// PART 3 — position the Check button and feedback text below everything
	// =====================================================================

	check_btn_width  = 60;
	check_btn_height = 16;
	check_btn_x1 = (room_width - check_btn_width) / 2;
	check_btn_y1 = bank_area_bottom + 8;
	check_btn_x2 = check_btn_x1 + check_btn_width;
	check_btn_y2 = check_btn_y1 + check_btn_height;

	feedback_y = check_btn_y2 + 10;

	feedback_text  = "";
	feedback_timer = 0;
	mistake_count  = 0; // for calculating how much score u get
}