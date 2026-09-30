/// obj_game - Draw Event

draw_set_font(fnt_pixel);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Language tabs
for (var i = 0; i < lesson_count; i++) {
    var bx1 = lang_button_x[i];
    var by1 = lang_button_y;
    var bx2 = bx1 + lang_button_width;
    var by2 = by1 + lang_button_height;

    draw_set_color(i == current_lesson ? c_yellow : c_black);
    draw_rectangle(bx1, by1, bx2, by2, false);
    draw_set_color(c_white);
    draw_rectangle(bx1 + 1, by1 + 1, bx2 - 1, by2 - 1, false);
    draw_set_color(c_black);
    draw_text((bx1 + bx2) / 2, (by1 + by2) / 2, lesson_names[i]);
}

// Empty slot outlines — each sized to its own token's width
draw_set_color(c_black);
for (var i = 0; i < word_count; i++) {
    draw_rectangle(slot_x[i], slot_y_row[i],
        slot_x[i] + slot_w[i], slot_y_row[i] + slot_height, true);
}

// Check button
draw_set_color(c_black);
draw_rectangle(check_btn_x1, check_btn_y1, check_btn_x2, check_btn_y2, false);
draw_set_color(c_white);
draw_rectangle(check_btn_x1 + 1, check_btn_y1 + 1, check_btn_x2 - 1, check_btn_y2 - 1, false);
draw_set_color(c_black);
draw_text((check_btn_x1 + check_btn_x2) / 2, (check_btn_y1 + check_btn_y2) / 2, "CHECK");

// Feedback
if (feedback_text != "") {
    draw_set_color(c_red);
    draw_text(room_width/2, feedback_y, feedback_text);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);