/// obj_block - Draw Event

var fill_color = dragging ? c_yellow : (current_slot != -1 ? c_lime : c_aqua);

draw_set_color(fill_color);
draw_rectangle(x, y, x + block_width, y + block_height, false);

draw_set_color(c_black);
draw_rectangle(x, y, x + block_width, y + block_height, true);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x + block_width/2, y + block_height/2, word_text);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);