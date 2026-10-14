/// obj_shop - Draw

draw_set_font(fnt_pixel);
draw_set_valign(fa_middle);

// --- Header: title (left) and coin balance (right) ---
draw_set_halign(fa_left);
draw_set_color(c_aqua);
draw_text(8, 10, "SHOP");

draw_set_halign(fa_right);
draw_set_color(c_yellow);
draw_text(room_width - 8, 10, "COINS: " + string(global.coins));

// --- Tabs: the open tab is highlighted ---
for (var i = 0; i < array_length(tabs); i++) {
    ui_button_draw(tab_x[i], tab_y, tab_w[i], tab_h, tabs[i], i == current_tab || i == hover_tab);
}

// --- Items in the open tab ---
var _row = 0;
for (var i = 0; i < array_length(items); i++) {
    if (items[i].tab != current_tab) continue;

    var _y     = row_y0 + _row * row_gap;
    var _mid   = _y + buy_h / 2;
    var _owned = variable_struct_exists(global.shop_owned, items[i].name);

    draw_set_font(fnt_pixel);
    draw_set_valign(fa_middle);

    // Name (left)
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_text(8, _mid, items[i].name);

    // Price (just left of the button)
    draw_set_halign(fa_right);
    draw_set_color(c_yellow);
    draw_text(buy_x - 8, _mid, string(items[i].price) + " C");

    // BUY / OWNED button
    ui_button_draw(buy_x, _y, buy_w, buy_h, _owned ? "OWNED" : "BUY", _row == hover_row && !_owned);

    _row++;
}

// --- Message ---
if (message_text != "") {
    draw_set_font(fnt_pixel);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(message_color);
    draw_text(room_width / 2, 160, message_text);
}

// --- BACK ---
ui_button_draw(back_x, back_y, back_w, back_h, back_label, hover_back);

// Reset so other objects aren't affected
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);