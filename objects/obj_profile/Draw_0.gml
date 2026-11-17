/// obj_profile - Draw Event

draw_set_font(fnt_pixel);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_aqua);
draw_text(room_width / 2, 16, "PROFILE");

// ---------- Account details ----------
var _loading = (profile_load_id != -1);
var _labels  = ["USERNAME", "EMAIL"];
var _values  = [display_username, display_email];

draw_set_halign(fa_left);
for (var i = 0; i < 2; i++) {
    var _ly = 36 + i * 28;
    draw_set_color(c_gray);
    draw_text(12, _ly, _labels[i]);

    var _v = _loading ? "LOADING..." : ((_values[i] == "") ? "-" : clip_text(_values[i], 29));
    draw_set_color(c_white);
    draw_text(12, _ly + 11, _v);
}

// ---------- Progress stats ----------
var _stats_loading = !global.progress_loaded;
var _xp_in_level   = progress_xp_in_level();

draw_set_color(c_gray);
draw_line(12, 92, room_width - 12, 92);

// Level (left) and total XP (right)
draw_set_halign(fa_left);
draw_set_color(c_aqua);
draw_text(12, 102, _stats_loading ? "LEVEL ..." : "LEVEL " + string(progress_level()));
draw_set_halign(fa_right);
draw_set_color(c_white);
draw_text(room_width - 12, 102, _stats_loading ? "... XP" : string(global.total_xp) + " XP");

// XP bar toward the next level
var _bar_x = 12;
var _bar_y = 112;
var _bar_w = room_width - 24;
var _bar_h = 8;
draw_set_color(c_dkgray);
draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, false);
if (!_stats_loading) {
    draw_set_color(c_lime);
    draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w * (_xp_in_level / XP_PER_LEVEL), _bar_y + _bar_h, false);
}
draw_set_color(c_white);
draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, true);

draw_set_halign(fa_center);
draw_set_color(c_gray);
draw_text(room_width / 2, 130, _stats_loading ? "..." : string(_xp_in_level) + " / " + string(XP_PER_LEVEL) + " TO NEXT LEVEL");

// Coins
draw_set_halign(fa_left);
draw_set_color(c_gray);
draw_text(12, 146, "COINS");
draw_set_halign(fa_right);
draw_set_color(c_yellow);
draw_text(room_width - 12, 146, _stats_loading ? "..." : string(global.coins));

// Streak
draw_set_halign(fa_left);
draw_set_color(c_gray);
draw_text(12, 160, "STREAK");
draw_set_halign(fa_right);
draw_set_color(c_orange);
var _streak_data = scr_streak_get_data();
var _streak_text = _streak_data.loading ? "..."
    : ((_streak_data.error != "") ? "UNAVAILABLE" : string(_streak_data.count)
    + ((_streak_data.count == 1) ? " DAY" : " DAYS"));
draw_text(room_width - 12, 160, _streak_text);

// Account created
draw_set_halign(fa_left);
draw_set_color(c_gray);
draw_text(12, 174, "JOINED");
draw_set_halign(fa_right);
draw_set_color(c_white);
draw_text(room_width - 12, 174, _loading ? "..." : ((display_created == "") ? "-" : display_created));

// ---------- Buttons ----------
ui_button_draw(edit_x, edit_y, edit_w, edit_h, edit_label, hover_edit);
ui_button_draw(achievements_x, edit_y, achievements_w, edit_h, achievements_label, hover_achievements);
ui_button_draw(back_x, back_y, back_w, back_h, back_label, hover_back);

// ---------- Status message ----------
if (profile_message != "") {
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(profile_message_color);
    draw_text_ext(room_width / 2, 210, profile_message, -1, room_width - 16);
}

// ---------- Earned achievements submenu ----------
if (achievements_open) {
    var _achievement_panel = make_color_rgb(26, 26, 58);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_color(c_aqua);
    draw_rectangle(8, 4, room_width - 8, room_height - 4, false);
    draw_set_color(_achievement_panel);
    draw_rectangle(10, 6, room_width - 10, room_height - 6, false);

    draw_set_font(fnt_pixel);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_aqua);
    draw_text(room_width / 2, 18, "ACHIEVEMENTS");
    draw_set_color(c_gray);
    draw_line(16, 28, room_width - 16, 28);

    if (achievements_request_id != -1) {
        draw_set_color(c_yellow);
        draw_text(room_width / 2, 96, "LOADING BADGES...");
    } else if (achievements_error != "") {
        draw_set_color(c_red);
        draw_text_ext(room_width / 2, 82, achievements_error, -1, room_width - 32);
    } else if (achievements_loaded && array_length(achievements_data) == 0) {
        draw_set_color(c_white);
        draw_text(room_width / 2, 82, "NO BADGES YET");
        draw_set_color(c_gray);
        draw_text(room_width / 2, 98, "KEEP COMPLETING LESSONS");
    } else if (achievements_loaded) {
        var _achievement_count = array_length(achievements_data);
        var _visible_rows = min(3, _achievement_count - achievements_scroll);

        for (var i = 0; i < _visible_rows; i++) {
            var _achievement = achievements_data[achievements_scroll + i];
            var _row_y = 34 + i * 48;

            draw_set_color(c_gray);
            draw_rectangle(16, _row_y, room_width - 16, _row_y + 42, false);
            draw_set_color(c_yellow);
            draw_rectangle(21, _row_y + 8, 41, _row_y + 28, false);
            draw_set_halign(fa_center);
            draw_set_color(c_black);
            var _badge_key = variable_struct_exists(_achievement, "badge_key")
                ? string_upper(_achievement.badge_key) : "*";
            draw_text(31, _row_y + 18, string_copy(_badge_key, 1, 2));

            draw_set_halign(fa_left);
            draw_set_color(c_white);
            var _achievement_name = variable_struct_exists(_achievement, "name")
                ? string_upper(_achievement.name) : "ACHIEVEMENT";
            draw_text(48, _row_y + 10, clip_text(_achievement_name, 24));

            draw_set_color(c_gray);
            var _achievement_description = variable_struct_exists(_achievement, "description")
                ? string_upper(_achievement.description) : "";
            draw_text(48, _row_y + 27, clip_text(_achievement_description, 25));
        }

        draw_set_halign(fa_center);
        draw_set_color(c_gray);
        draw_text(room_width / 2, 180, string(_achievement_count) + " EARNED");
        if (_achievement_count > 3) draw_text(room_width / 2, 194, "UP/DOWN TO SCROLL");
    }

    ui_button_draw(achievements_back_x, achievements_back_y,
        achievements_back_w, achievements_back_h, achievements_back_label, hover_achievements_back);
}

// ---------- Edit Account popup ----------
if (edit_open) {
    var _panel_bg   = make_color_rgb(26, 26, 58);
    var _field_bg   = make_color_rgb(10, 10, 30);
    var _caret      = ((current_time div 500) mod 2 == 0) ? "_" : " ";

    // Solid backdrop (nothing from the profile screen shows through)
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);

    // Panel: 2px aqua frame around a navy body
    draw_set_color(c_aqua);
    draw_rectangle(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h, false);
    draw_set_color(_panel_bg);
    draw_rectangle(panel_x + 2, panel_y + 2, panel_x + panel_w - 2, panel_y + panel_h - 2, false);

    // Title + divider
    draw_set_valign(fa_middle);
    draw_set_halign(fa_center);
    draw_set_color(c_aqua);
    draw_text(room_width / 2, 18, "EDIT ACCOUNT");
    draw_set_color(c_gray);
    draw_line(panel_x + 8, 28, panel_x + panel_w - 8, 28);

    draw_set_halign(fa_left);

    // Field table: label, y position, field id
    var _names = ["USERNAME", "EMAIL", "NEW PASSWORD"];
    var _ys    = [user_y, email_y, pass_y];

    for (var i = 0; i < 3; i++) {
        var _fy     = _ys[i];
        var _active = (edit_field == i + 1);

        // Label sits just above its box
        draw_set_color(_active ? c_yellow : c_gray);
        draw_text(field_x, _fy - 8, _names[i]);

        // Box: 1px border (yellow when active), dark fill
        draw_set_color(_active ? c_yellow : c_gray);
        draw_rectangle(field_x, _fy, field_x + field_w, _fy + field_h, false);
        draw_set_color(_field_bg);
        draw_rectangle(field_x + 1, _fy + 1, field_x + field_w - 1, _fy + field_h - 1, false);

        // Contents
        var _text = "";
        if (i == 0) _text = edit_username;
        if (i == 1) _text = edit_email;
        if (i == 2) _text = string_repeat("*", string_length(edit_password));

        if (i == 2 && edit_password == "" && !_active) {
            draw_set_color(c_gray);
            draw_text(field_x + 5, _fy + field_h / 2, "BLANK = KEEP CURRENT");
        } else {
            draw_set_color(c_white);
            draw_text(field_x + 5, _fy + field_h / 2, fit_text(_text + (_active ? _caret : "")));
        }
    }

    // Buttons
    ui_button_draw(save_x,   popup_btn_y, save_w,   popup_btn_h, busy ? "SAVING" : "SAVE", hover_save);
    ui_button_draw(cancel_x, popup_btn_y, cancel_w, popup_btn_h, "CANCEL", hover_cancel);

    // Popup message
    if (edit_message != "") {
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_set_color(edit_message_color);
        draw_text_ext(room_width / 2, msg_y, edit_message, -1, panel_w - 24);
    }
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
