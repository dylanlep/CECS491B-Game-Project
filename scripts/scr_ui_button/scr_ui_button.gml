/// scr_ui_button
/// Reusable pixel-style buttons for menus (title screen, mode hub, shop).

/// Width a button needs to fit its label (8 px padding each side).
function ui_button_width(_label) {
    draw_set_font(fnt_pixel);
    return string_width(_label) + 16;
}

/// True if the mouse is inside the rectangle.
function ui_mouse_over(_x, _y, _w, _h) {
    return mouse_x >= _x && mouse_x <= _x + _w
        && mouse_y >= _y && mouse_y <= _y + _h;
}

/// Draws one button. _focused = true draws the highlighted (yellow) box.
function ui_button_draw(_x, _y, _w, _h, _label, _focused) {
    draw_set_font(fnt_pixel);
    draw_sprite_stretched(_focused ? spr_ui_box_focus : spr_ui_box, 0, _x, _y, _w, _h);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(_focused ? c_yellow : c_white);
    draw_text(_x + _w / 2, _y + _h / 2, _label);

    // Reset so other objects aren't affected
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}