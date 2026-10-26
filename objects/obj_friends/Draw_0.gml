/// obj_friends - Draw Event (Friend Hub)

var list  = get_list();
var count = array_length(list);
var n_req = array_length(global.friend_requests);

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

// ---------- Tabs ----------
for (var t = 0; t < 3; t++) {
    var tx1 = tab_x[t];
    var tx2 = tx1 + tab_w;
    var ty1 = tab_y;
    var ty2 = tab_y + tab_h;
    var sel = (tab == t);

    draw_set_color(c_black);
    draw_rectangle(tx1, ty1, tx2, ty2, false);
    draw_set_color(sel ? c_white : make_color_rgb(40, 40, 80));
    draw_rectangle(tx1 + 1, ty1 + 1, tx2 - 1, ty2 - 1, false);

    var label = tab_label[t];
    if (t == 2 && n_req > 0) label += " (" + string(n_req) + ")";

    if (sel)                        draw_set_color(c_black);
    else if (t == 2 && n_req > 0)   draw_set_color(c_yellow); // pending requests
    else                            draw_set_color(c_white);

    draw_text((tx1 + tx2) / 2, (ty1 + ty2) / 2, label);
}

// ---------- Search bar (SEARCH tab only) ----------
if (tab == 1) {
    draw_set_color(search_focused ? c_yellow : c_black);
    draw_rectangle(search_x, search_y, search_x + search_w, search_y + search_h, false);
    draw_set_color(make_color_rgb(26, 26, 58));
    draw_rectangle(search_x + 2, search_y + 2, search_x + search_w - 2, search_y + search_h - 2, false);

    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);

    if (query == "" && !search_focused) {
        draw_set_color(c_gray);
        draw_text(search_x + 6, search_y + search_h / 2, "TYPE NAME + ENTER");
    } else {
        draw_set_color(c_white);
        var shown = query;
        if (search_focused && ((cursor_blink div 30) mod 2 == 0)) shown += "_";
        draw_text(search_x + 6, search_y + search_h / 2, shown);
    }
}

// ---------- Empty states ----------
if (count == 0) {
    var msg;
    if (tab == 0)      msg = "NO FRIENDS YET";
    else if (tab == 1) msg = searched ? "NO USERS FOUND" : "TYPE A NAME, PRESS ENTER";
    else               msg = "NO REQUESTS";

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_gray);
    draw_text(room_width / 2, list_top + 30, msg);
}

// ---------- Rows ----------
for (var r = 0; r < visible_rows; r++) {
    var idx = scroll + r;
    if (idx >= count) break;

    var item = list[idx];
    var ry   = list_top + r * (row_height + row_gap);

    // Row box: black border, navy fill (same look as the login boxes)
    draw_set_color(c_black);
    draw_rectangle(list_x, ry, list_x + list_w, ry + row_height, false);
    draw_set_color(make_color_rgb(26, 26, 58));
    draw_rectangle(list_x + 2, ry + 2, list_x + list_w - 2, ry + row_height - 2, false);

    var b0 = get_btn(r, 0);
    var b1 = get_btn(r, 1);

    // Name (trimmed so it can't run into the XP column)
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(list_x + 8, ry + row_height / 2, string_copy(item.name, 1, 11));

    // XP sits just left of the left-most button
    var left_btn = (tab == 2) ? b1 : b0;
    draw_set_halign(fa_right);
    draw_set_color(make_color_rgb(220, 220, 170));
    draw_text(left_btn[0] - 6, ry + row_height / 2, string(item.xp) + " XP");

    // Buttons
    if (tab == 0) {
        var confirming = (confirm_index == idx);
        draw_btn(b0,
            confirming ? "SURE?" : "REMOVE",
            confirming ? c_yellow : make_color_rgb(200, 60, 60),
            confirming ? c_black  : c_white,
            true);

    } else if (tab == 1) {
        var st = user_state(item);
        if (st == 0)      draw_btn(b0, "ADD",    make_color_rgb(60, 170, 80),  c_white, true);
        else if (st == 1) draw_btn(b0, "FRIEND", make_color_rgb(90, 90, 90),   c_white, false);
        else if (st == 2) draw_btn(b0, "SENT",   make_color_rgb(90, 90, 90),   c_white, false);
        else              draw_btn(b0, "ACCEPT", make_color_rgb(60, 120, 200), c_white, true);

    } else {
        draw_btn(b1, "OK", make_color_rgb(60, 170, 80), c_white, true);
        draw_btn(b0, "NO", make_color_rgb(200, 60, 60), c_white, true);
    }
}

// ---------- Scroll hints (bright = more rows that way) ----------
draw_set_halign(fa_right);
draw_set_valign(fa_middle);
var mid_y = (close_y1 + close_y2) / 2;
draw_set_color(scroll > 0 ? c_white : make_color_rgb(60, 60, 90));
draw_text(panel_x + panel_w - 22, mid_y, "^");
draw_set_color((scroll + visible_rows < count) ? c_white : make_color_rgb(60, 60, 90));
draw_text(panel_x + panel_w - 8, mid_y, "v");

// ---------- Close button ----------
draw_btn([close_x1, close_y1, close_x2, close_y2], "CLOSE",
    make_color_rgb(212, 212, 212), c_black, true);

// Reset drawing state so nothing leaks into other objects
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);