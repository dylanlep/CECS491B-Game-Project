/// obj_concept_card - Draw

// Dim the lesson behind the card
draw_set_alpha(0.8);
draw_set_color(c_black);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1);

// Card
draw_sprite_stretched(spr_ui_box, 0, px, py, pw, ph);
draw_set_font(fnt_pixel);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

draw_set_color(c_ltgray);
draw_text(room_width / 2, py + 8, "NEW CONCEPT");

draw_set_color(c_aqua);
draw_text(room_width / 2, py + 22, card.title);

draw_set_color(c_white);
draw_text_ext(room_width / 2, py + 42, card.text, 12, pw - 24);

// Example box: the code, and what it shows
var _bx = px + 12;
var _by = py + 100;
var _bw = pw - 24;
var _bh = 44;
draw_set_color(c_black);
draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
draw_set_color(c_dkgray);
draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, true);

draw_set_halign(fa_left);
draw_set_color(c_ltgray);
draw_text(_bx + 6, _by + 6, "CODE: ");
draw_set_color(c_yellow);
draw_text(_bx + 6 + string_width("CODE: "), _by + 6, card.example);

draw_set_color(c_ltgray);
draw_text(_bx + 6, _by + 26, "SHOWS: ");
draw_set_color(c_lime);
draw_text(_bx + 6 + string_width("SHOWS: "), _by + 26, card.output);

// GOT IT!
ui_button_draw(btn_x, btn_y, btn_w, btn_h, btn_label, hovered);

// Reset so other objects aren't affected
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);