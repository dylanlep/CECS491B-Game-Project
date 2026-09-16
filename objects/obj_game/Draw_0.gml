/// obj_game - Draw Event

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_color(c_white);
draw_text(room_width/2, 50, "Drag the blocks into the correct order:");

// Language buttons
for (var i = 0; i < lesson_count; i++) {
    var bx1 = lang_button_x[i];
    var by1 = lang_button_y;
    var bx2 = bx1 + lang_button_width;
    var by2 = by1 + lang_button_height;

    draw_set_color(i == current_lesson ? c_orange : c_gray);
    draw_rectangle(bx1, by1, bx2, by2, false);
    draw_set_color(c_black);
    draw_rectangle(bx1, by1, bx2, by2, true);
    draw_set_color(c_white);
    draw_text((bx1 + bx2) / 2, (by1 + by2) / 2, lesson_names[i]);
}

// Slot outlines — hug the occupying chip's exact size once one is dropped
// in, so there's no leftover empty space. Empty slots still show the
// original placeholder size. Both cases are centered on slot_center_x/y.
var hug_pad = 6; // small breathing room around a snapped chip; set to 0 for a true skin-tight fit

draw_set_color(c_ltgray);
for (var i = 0; i < word_count; i++) {

    var outline_w = slot_width;
    var outline_h = slot_height;

    if (slot_occupant[i] != noone) {
        outline_w = slot_occupant[i].block_width + hug_pad;
        outline_h = slot_occupant[i].block_height + hug_pad;
    }

    var ox1 = slot_center_x[i] - outline_w / 2;
    var oy1 = slot_center_y  - outline_h / 2;
    var ox2 = slot_center_x[i] + outline_w / 2;
    var oy2 = slot_center_y  + outline_h / 2;

    draw_rectangle(ox1, oy1, ox2, oy2, true);
}

// Check button
var cx1 = room_width/2 - 70;
var cy1 = 560;
var cx2 = room_width/2 + 70;
var cy2 = 605;

draw_set_color(c_green);
draw_rectangle(cx1, cy1, cx2, cy2, false);
draw_set_color(c_black);
draw_rectangle(cx1, cy1, cx2, cy2, true);
draw_set_color(c_white);
draw_text((cx1 + cx2) / 2, (cy1 + cy2) / 2, "Check");

// Feedback
if (feedback_text != "") {
    draw_set_color(c_yellow);
    draw_text(room_width/2, 640, feedback_text);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);