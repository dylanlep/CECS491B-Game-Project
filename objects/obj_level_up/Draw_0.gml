/// obj_level_up - Draw

var _open = min(1, timer / 12);          // 0 -> 1 over the first 12 frames
var _ease = 1 - power(1 - _open, 3);     // ease-out, so it "pops" open
var _cx   = room_width / 2;
var _cy   = py + ph / 2;

// Dim whatever is behind
draw_set_alpha(0.75 * _ease);
draw_set_color(c_black);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1);

// Panel grows out from the centre: 2px yellow frame, same dark fill as spr_ui_box.
// (Drawn with rectangles because stretching spr_ui_box this big thickens its border.)
var _hw = max(4, pw * _ease) / 2;
var _hh = max(4, ph * _ease) / 2;
draw_set_color(make_color_rgb(255, 221, 0));
draw_rectangle(_cx - _hw, _cy - _hh, _cx + _hw - 1, _cy + _hh - 1, false);
draw_set_color(make_color_rgb(26, 26, 58));
draw_rectangle(_cx - _hw + 2, _cy - _hh + 2, _cx + _hw - 3, _cy + _hh - 3, false);

if (_open >= 1) {
    draw_set_font(fnt_pixel);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Sparkles circling the title, twinkling on and off
    var _ty = py + 22;
    for (var i = 0; i < 8; i++) {
        if (((timer div 6) + i) mod 3 == 0) continue;
        var _a  = i * 45 + timer * 1.5;
        var _sx = round(_cx + lengthdir_x(90, _a));
        var _sy = round(_ty + lengthdir_y(14, _a));
        draw_set_color((i mod 2 == 0) ? c_yellow : c_aqua);
        draw_rectangle(_sx - 1, _sy - 1, _sx, _sy, false);
    }

    // Title, bobbing gently
    draw_set_color(c_yellow);
    draw_text_transformed(_cx, _ty + round(sin(timer * 0.1)), "LEVEL UP!", 2, 2, 0);

    // New level
    draw_set_color(c_white);
    draw_text(_cx, py + 46, "YOU REACHED LEVEL " + string(new_level));

    // XP bar toward the next level
    draw_set_color(c_dkgray);
    draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false);
    if (bar_fill > 0.01) {
        draw_set_color(c_lime);
        draw_rectangle(bar_x, bar_y, bar_x + bar_w * bar_fill, bar_y + bar_h, false);
    }
    draw_set_color(c_white);
    draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, true);

    draw_set_color(c_ltgray);
    draw_text(_cx, bar_y + bar_h + 10,
        string(progress_xp_in_level()) + "/" + string(XP_PER_LEVEL) + " XP TO LEVEL " + string(new_level + 1));

    ui_button_draw(btn_x, btn_y, btn_w, btn_h, btn_label, hovered);
}

// Reset so other objects aren't affected
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);