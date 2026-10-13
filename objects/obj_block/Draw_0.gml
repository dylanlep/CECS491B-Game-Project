/// obj_block - Draw Event

var border_color;
if (dragging) {
    border_color = c_yellow;
} else if (current_slot != -1) {
    border_color = c_lime;
} else {
    border_color = c_black;
}

var draw_w = block_width  * display_scale;
var draw_h = block_height * display_scale;
var draw_x = x - (draw_w - block_width)  / 2;
var draw_y = y - (draw_h - block_height) / 2;

draw_set_color(border_color);
draw_rectangle(draw_x, draw_y, draw_x + draw_w, draw_y + draw_h, false);

draw_set_color(base_color);
draw_rectangle(draw_x + border_thickness, draw_y + border_thickness,
                draw_x + draw_w - border_thickness, draw_y + draw_h - border_thickness, false);

// ---------- Text, auto-scaled to always leave a clean margin ----------
draw_set_font(fnt_pixel);

var text_padding = 4; // px of guaranteed breathing room on every side

var raw_w = string_width(word_text);
var raw_h = string_height(word_text);

var max_w = draw_w - (text_padding * 2);
var max_h = draw_h - (text_padding * 2);

var text_scale = min(1, max_w / raw_w, max_h / raw_h);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_black);
draw_text_transformed(draw_x + draw_w/2, draw_y + draw_h/2, word_text, text_scale, text_scale, 0);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);