/// obj_friends - Draw Event

var friend_count = array_length(global.friends);

// ---------- Dim the screen underneath ----------
draw_set_color(c_black);
draw_set_alpha(0.7);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1);

// ---------- Panel: white border, dark fill ----------
draw_set_color(c_white);
draw_rectangle(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h, false);
draw_set_color(make_color_rgb(16, 16, 36));
draw_rectangle(panel_x + 2, panel_y + 2, panel_x + panel_w - 2, panel_y + panel_h - 2, false);

draw_set_font(fnt_pixel);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Title
draw_set_color(c_white);
draw_text(room_width/2, panel_y + 12, "FRIENDS (" + string(friend_count) + ")");

// Empty state
if (friend_count == 0) {
    draw_set_color(c_gray);
    draw_text(room_width/2, panel_y + panel_h/2, "NO FRIENDS YET");
}

// ---------- Rows ----------
for (var r = 0; r < visible_rows; r++) {
    var idx = scroll + r;
    if (idx >= friend_count) break;

    var f  = global.friends[idx];
    var ry = list_y + r * (row_height + row_gap);

    // Row box: black border, navy fill (same look as the login boxes)
    draw_set_color(c_black);
    draw_rectangle(list_x, ry, list_x + list_w, ry + row_height, false);
    draw_set_color(make_color_rgb(26, 26, 58));
    draw_rectangle(list_x + 2, ry + 2, list_x + list_w - 2, ry + row_height - 2, false);

    // Remove button geometry
    var bx1 = list_x + list_w - 4 - remove_w;
    var by1 = ry + 3;
    var bx2 = bx1 + remove_w;
    var by2 = ry + row_height - 3;

    // Name (trimmed so it can't run into the XP column)
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(list_x + 8, ry + row_height/2, string_copy(f.name, 1, 11));

    // XP
    draw_set_halign(fa_right);
    draw_set_color(make_color_rgb(220, 220, 170));
    draw_text(bx1 - 6, ry + row_height/2, string(f.xp) + " XP");

    // Remove button: red, brighter on hover, yellow while waiting for confirm
    var hovered    = point_in_rectangle(mouse_x, mouse_y, bx1, by1, bx2, by2);
    var confirming = (confirm_index == idx);

    var btn_color;
    if (confirming)   btn_color = c_yellow;
    else if (hovered) btn_color = make_color_rgb(235, 90, 90);
    else              btn_color = make_color_rgb(200, 60, 60);

    draw_set_color(c_black);
    draw_rectangle(bx1, by1, bx2, by2, false);
    draw_set_color(btn_color);
    draw_rectangle(bx1 + 1, by1 + 1, bx2 - 1, by2 - 1, false);

    draw_set_halign(fa_center);
    draw_set_color(confirming ? c_black : c_white);
    draw_text((bx1 + bx2) / 2, (by1 + by2) / 2, confirming ? "SURE?" : "REMOVE");
}

// ---------- Scroll hints ----------
draw_set_halign(fa_right);
draw_set_color(c_gray);
if (scroll > 0)                            draw_text(panel_x + panel_w - 8, panel_y + 12, "^");
if (scroll + visible_rows < friend_count)  draw_text(panel_x + panel_w - 8, close_y1 + close_h/2, "v");

// ---------- Close button ----------
var close_hover = point_in_rectangle(mouse_x, mouse_y, close_x1, close_y1, close_x2, close_y2);
draw_set_color(c_black);
draw_rectangle(close_x1, close_y1, close_x2, close_y2, false);
draw_set_color(close_hover ? c_white : make_color_rgb(212, 212, 212));
draw_rectangle(close_x1 + 1, close_y1 + 1, close_x2 - 1, close_y2 - 1, false);
draw_set_halign(fa_center);
draw_set_color(c_black);
draw_text((close_x1 + close_x2) / 2, (close_y1 + close_y2) / 2, "CLOSE");

// Reset drawing state so nothing leaks into other objects
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);