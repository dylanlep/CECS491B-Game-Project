/// obj_game - Draw Event

draw_set_font(fnt_pixel);

if (account_open) {
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(room_width/2, 40, "EDIT ACCOUNT");
    draw_set_halign(fa_left);
    draw_text(12, 68, "NEW EMAIL");
    draw_sprite_stretched(account_active_field == 1 ? spr_ui_box_focus : spr_ui_box, 0, 82, 64, 162, 24);
    draw_text(86, 76, account_email_input == "" ? "EMAIL" : account_email_input);
    draw_text(12, 106, "NEW PASS");
    draw_sprite_stretched(account_active_field == 2 ? spr_ui_box_focus : spr_ui_box, 0, 82, 102, 162, 24);
    var _masked_account_password = string_repeat("*", string_length(account_password_input));
    draw_text(86, 114, account_password_input == "" ? "PASSWORD" : _masked_account_password);
    draw_set_halign(fa_center);
    draw_sprite_stretched(spr_ui_box, 0, room_width/2 - 36, 150, 72, 20);
    draw_set_color(c_black);
    draw_text(room_width/2, 160, account_busy ? "SAVING" : "SAVE");
    draw_set_color(c_aqua);
    draw_text(room_width/2, 188, "BACK");
    if (account_message != "") {
        draw_set_color(c_yellow);
        draw_text_ext(room_width/2, 212, account_message, -1, room_width - 16);
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    exit;
}

draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_sprite_stretched(spr_ui_box, 0, 4, 22, 44, 14);
draw_set_color(c_black);
draw_text(26, 29, "ACC");

// XP / score display — own alignment, drawn first
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text(room_width - 4, 4, "XP: " + string(language_scores[current_lesson]));

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Language tabs
var show_language_tabs = room == rm_python_map;
for (var i = 0; show_language_tabs && i < lesson_count; i++) {
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




if (room == rm_python_map) {
    draw_set_color(c_white);
    var python_selected = current_lesson == 0;
    var map_level_count = python_selected ? array_length(global.python_levels) : map_placeholder_count;
    draw_text(room_width / 2, 38, string_upper(lesson_names[current_lesson]) + " WORLD 1");
    for (var i = 0; i < map_level_count; i++) {
        var button_y = map_button_y + i * map_button_stride;
        draw_sprite_stretched(spr_ui_box, 0, map_button_x, button_y,
            map_button_width, map_button_height);
        draw_set_color(c_black);
        var button_label = "LEVEL " + string(i + 1);
        if (!python_selected) {
            button_label += " - TBD";
        } else if (global.python_completed[i]) {
            button_label += " - DONE";
        }
        draw_text(room_width / 2, button_y + map_button_height / 2, button_label);
    }
    if (python_selected) {
        draw_set_color(c_white);
        draw_text(room_width / 2, 201, global.python_map_feedback);
        draw_text(room_width / 2, 218, global.python_map_output);
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    exit;
}

// ---------- Level title, hint and fixed code text (Python levels) ----------
if (hint_text != "") {
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_yellow);
    draw_text(room_width / 2, slot_area_y_start - 2,
        "LEVEL " + string(current_level + 1) + ": " + level_title);
    draw_set_color(c_ltgray);
    draw_text_ext(room_width / 2, slot_area_y_start + 9, hint_text, -1, room_width - 20);
}

draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_color(c_white);
for (var f = 0; f < fixed_n; f++) {
    draw_text(fixed_x[f], fixed_y[f], fixed_text[f]);
}

// restore what the rest of this event assumes
draw_set_halign(fa_center);
draw_set_valign(fa_middle);






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
