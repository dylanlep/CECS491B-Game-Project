/// obj_game - Draw Event

draw_set_font(fnt_pixel);

if (level_complete_open) {
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_color(c_yellow);
    draw_text_transformed(room_width/2, 28, "LEVEL COMPLETE!", 1.5, 1.5, 0);

    draw_set_color(c_aqua);
    draw_text(room_width/2, 50, lc_lang);

    draw_set_color(lc_mistakes == 0 ? c_lime : c_white);
    draw_text(room_width/2, 68, lc_mistakes == 0 ? "PERFECT! NO MISTAKES" : "MISTAKES: " + string(lc_mistakes));

    // Hints + time
    var _secs     = floor(lc_time);
    var _time_str = string(_secs div 60) + ":" + (((_secs mod 60) < 10) ? "0" : "") + string(_secs mod 60);

    draw_set_color(lc_hints == 0 ? c_lime : c_aqua);
    draw_text(room_width/2, 82, "HINTS USED: " + string(lc_hints));
    draw_set_color(c_white);
    draw_text(room_width/2, 94, "TIME: " + _time_str);

    // Earned this level
    draw_set_color(c_lime);
    draw_text(room_width/2, 112, "XP EARNED: +" + string(lc_xp));
    draw_set_color(c_yellow);
    draw_text(room_width/2, 126, "COINS EARNED: +" + string(lc_coins));

    // Totals
    draw_set_color(c_white);
    draw_text(room_width/2, 146, "TOTAL " + lc_lang + " XP: " + string(language_scores[current_lesson]));
    draw_text(room_width/2, 160, "TOTAL COINS: " + string(global.coins));

    draw_set_color(c_orange);
    draw_text(room_width/2, 178, "DAY STREAK: " + string(lc_streak));

    for (var i = 0; i < 2; i++) {
        ui_button_draw(lc_btn_x[i], lc_btn_y, lc_btn_w[i], lc_btn_h, lc_btn_label[i], lc_hover == i);
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    exit;
}

if (pause_settings_active) {
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_aqua);
    draw_text(room_width/2, 30, "SETTINGS");
    draw_set_color(c_gray);
    draw_text(room_width/2, room_height - 14, "ESC = BACK");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    exit;
}

if (pause_open) {
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_aqua);
    draw_text_transformed(room_width/2, 44, "PAUSED", 2, 2, 0);

    for (var i = 0; i < array_length(pause_labels); i++) {
        ui_button_draw(pause_btn_x, pause_btn_y0 + i * (pause_btn_h + pause_btn_gap),
                       pause_btn_w, pause_btn_h, pause_labels[i], i == pause_selected);
    }

    if (pause_message != "") {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_red);
        draw_text(room_width/2, 190, pause_message);
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    exit;
}

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

// Hint button
draw_set_color(c_black);
draw_rectangle(hint_btn_x1, hint_btn_y1, hint_btn_x2, hint_btn_y2, false);
draw_set_color(c_white);
draw_rectangle(hint_btn_x1 + 1, hint_btn_y1 + 1, hint_btn_x2 - 1, hint_btn_y2 - 1, false);
draw_set_color(c_black);
draw_text((hint_btn_x1 + hint_btn_x2) / 2, (hint_btn_y1 + hint_btn_y2) / 2, "HINT");

// Check button
draw_set_color(c_black);
draw_rectangle(check_btn_x1, check_btn_y1, check_btn_x2, check_btn_y2, false);
draw_set_color(c_white);
draw_rectangle(check_btn_x1 + 1, check_btn_y1 + 1, check_btn_x2 - 1, check_btn_y2 - 1, false);
draw_set_color(c_black);
draw_text((check_btn_x1 + check_btn_x2) / 2, (check_btn_y1 + check_btn_y2) / 2, "CHECK");

// Feedback
if (feedback_text != "") {
    draw_set_color(feedback_is_hint ? c_aqua : c_red);
    draw_text_ext(room_width/2, feedback_y, feedback_text, -1, room_width - 12);
}

// PAUSE button
ui_button_draw(pause_open_x, pause_open_y, pause_open_w, pause_open_h, pause_open_label,
               ui_mouse_over(pause_open_x, pause_open_y, pause_open_w, pause_open_h));

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
