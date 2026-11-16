/// obj_audio_settings - Draw

// Dim the screen behind the panel
draw_set_alpha(0.8);
draw_set_color(c_black);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1);

// Panel + title
draw_sprite_stretched(spr_ui_box, 0, px, py, pw, ph);
draw_set_font(fnt_pixel);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_aqua);
draw_text(room_width / 2, py + 14, "SETTINGS");
draw_set_color(c_ltgray);
draw_text(room_width / 2, py + 26, "AUDIO");

// Rows
for (var r = 0; r < 3; r++) {
    var _y  = row_y[r];
    var _cy = _y + 8;

    draw_set_halign(fa_left);
    draw_set_color(row == r ? c_yellow : c_white);
    draw_text(label_x, _cy, row_label[r]);

    if (r < 2) {
        var _v = (r == 0) ? global.audio_music : global.audio_sfx;
        ui_button_draw(minus_x, _y, btn_s, 16, "-", hover == "minus" + string(r));
        ui_button_draw(plus_x,  _y, btn_s, 16, "+", hover == "plus"  + string(r));

        var _by = _cy - bar_h / 2;
        draw_set_color(c_dkgray);
        draw_rectangle(bar_x, _by, bar_x + bar_w, _by + bar_h, false);
        draw_set_color(global.audio_muted ? c_gray : c_lime);
        if (_v > 0) draw_rectangle(bar_x, _by, bar_x + bar_w * _v, _by + bar_h, false);
        draw_set_color(c_white);
        draw_rectangle(bar_x, _by, bar_x + bar_w, _by + bar_h, true);

        draw_set_font(fnt_pixel);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text(value_x, _cy, string(round(_v * 100)) + "%");
    } else {
        ui_button_draw(minus_x, _y, mute_w, 16, global.audio_muted ? "ON" : "OFF", hover == "mute" || row == 2);
    }
    draw_set_font(fnt_pixel);
    draw_set_valign(fa_middle);
}

// Key hint + BACK
draw_set_halign(fa_center);
draw_set_color(c_gray);
draw_text(room_width / 2, back_y - 10, "ARROWS: CHANGE    ESC: BACK");
ui_button_draw(back_x, back_y, back_w, back_h, back_label, hover == "back" || row == 3);

// Reset so other objects aren't affected
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);