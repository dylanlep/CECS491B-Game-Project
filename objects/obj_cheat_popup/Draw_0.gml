/// obj_cheat_popup - Draw GUI

// Shake: small random offset while the timer runs
var _ox = (shake_timer > 0) ? irandom_range(-3, 3) : 0;
var _oy = (shake_timer > 0) ? irandom_range(-3, 3) : 0;

// Dim everything behind
draw_set_alpha(0.75);
draw_set_color(c_black);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);

// Panel
draw_sprite_stretched(spr_ui_box, 0, panel_x + _ox, panel_y + _oy, panel_w, panel_h);

// Blinking banner
draw_set_font(fnt_pixel);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color((flash_timer div 10) mod 2 == 0 ? c_red : c_yellow);
draw_text(panel_x + panel_w / 2 + _ox, panel_y + 14 + _oy, "!! CHEAT DETECTED !!");

// Message, typed out letter by letter (wraps to fit the panel)
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text_ext(panel_x + 12 + _ox, panel_y + 32 + _oy,
              string_copy(message, 1, floor(shown_chars)), 12, panel_w - 24);

// Buttons
ui_button_draw(sorry_x + _ox, sorry_y + _oy, sorry_w, btn_h, sorry_label, hover_sorry);
ui_button_draw(nope_x + _ox, nope_y + _oy, nope_w, btn_h, nope_label, false);

// Reset
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);