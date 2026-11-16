/// obj_reset_button - Draw
// Same look as the HINT / CHECK buttons; turns yellow when hovered.

if (!instance_exists(obj_game) || is_frozen()) exit;

var _g  = instance_find(obj_game, 0);
var _x1 = _g.reset_btn_x1;
var _y1 = _g.reset_btn_y1;
var _x2 = _g.reset_btn_x2;
var _y2 = _g.reset_btn_y2;

draw_set_font(fnt_pixel);
draw_set_color(c_black);
draw_rectangle(_x1, _y1, _x2, _y2, false);
draw_set_color(hovered ? c_yellow : c_white);
draw_rectangle(_x1 + 1, _y1 + 1, _x2 - 1, _y2 - 1, false);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_black);
draw_text((_x1 + _x2) / 2, (_y1 + _y2) / 2, "RESET");

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);