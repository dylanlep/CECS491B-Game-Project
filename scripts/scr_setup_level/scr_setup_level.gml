/// scr_setup_level()
/// Builds the board for global.python_levels[current_level].

function scr_setup_level() {

    with (obj_block) {
        instance_destroy();
    }

    draw_set_font(fnt_pixel); // string_width below needs the right font

    var level_row_height = 22;
    var lvl = global.python_levels[current_level];
    level_title = lvl.title;
    hint_text   = lvl.hint;

    // Width of every blank in a Fill level: as wide as the widest block,
    // so any block fits any blank (a wrong block must not overflow).
    var fill_w = 0;
    for (var i = 0; i < array_length(lvl.blocks); i++) {
        fill_w = max(fill_w, string_width(lvl.blocks[i]) + chip_padding);
    }

    // =====================================================================
    // PART 1: lay out the code lines (fixed text and blanks, left to right)
    // =====================================================================
    word_count = 0; // number of blanks (obj_block reads this name)
    fixed_n    = 0; // number of fixed-text pieces

    // Reserve room for the level title and a two-line hint above the code
    var sy = slot_area_y_start + 32;

    for (var L = 0; L < array_length(lvl.lines); L++) {
        var line = lvl.lines[L];
        var sx   = side_margin;

        for (var p = 0; p < array_length(line); p++) {
            var part = line[p];

            if (part == "@") {
                var a = lvl.answer[word_count];
                var w = (lvl.mode == "fill") ? fill_w : (string_width(a) + chip_padding);

                slot_x[word_count]        = sx;
                slot_y_row[word_count]    = sy;
                slot_w[word_count]        = w;
                slot_answer[word_count]   = a;
                slot_occupant[word_count] = noone;

                word_count += 1;
                sx += w + chip_spacing;
            } else {
                fixed_text[fixed_n] = part;
                fixed_x[fixed_n]    = sx;
                fixed_y[fixed_n]    = sy + level_row_height / 2;

                fixed_n += 1;
                sx += string_width(part) + chip_spacing;
            }
        }

        sy += level_row_height + row_spacing;
    }

    slot_height = level_row_height;

    // =====================================================================
    // PART 2: shuffle the blocks and lay out the bank (wraps to new rows)
    // =====================================================================
    var n     = array_length(lvl.blocks);
    var order = array_create(n);
    var tries = 0;

    do {
        for (var i = 0; i < n; i++) order[i] = i;
        for (var i = n - 1; i > 0; i--) {
            var j   = irandom(i);
            var tmp = order[i];
            order[i] = order[j];
            order[j] = tmp;
        }

        // Don't start a Reorder level already solved
        var same = true;
        for (var i = 0; i < n; i++) {
            if (order[i] != i) { same = false; break; }
        }
        tries += 1;
    } until (!same || n < 2 || tries > 20);

    var bx = side_margin;
    var by = sy + 6;

    for (var i = 0; i < n; i++) {
        var word = lvl.blocks[order[i]];
        var w    = string_width(word) + chip_padding;

        if (bx + w > room_width - side_margin) {
            bx = side_margin;
            by += level_row_height + row_spacing;
        }

        var inst = instance_create_layer(bx, by, "Instances", obj_block);
        inst.word_text      = word;
        inst.correct_index  = -1; // not used in level mode, checking is by text
        inst.block_width    = w;
        inst.block_height   = level_row_height;
        inst.home_x         = bx;
        inst.home_y         = by;
        inst.current_slot   = -1;
        inst.token_category = scr_classify_token(word);
        inst.base_color     = scr_get_token_color(inst.token_category);

        bx += w + chip_spacing;
    }

    var bank_bottom = by + level_row_height;

    // =====================================================================
    // PART 3: Check button and feedback below everything
    // =====================================================================
    check_btn_width  = 60;
    check_btn_height = 16;
    check_btn_x1 = (room_width - check_btn_width) / 2;
    check_btn_y1 = bank_bottom + 8;
    check_btn_x2 = check_btn_x1 + check_btn_width;
    check_btn_y2 = check_btn_y1 + check_btn_height;

    feedback_y     = check_btn_y2 + 10;
    feedback_text  = "";
    feedback_timer = 0;
    mistake_count  = 0;
}