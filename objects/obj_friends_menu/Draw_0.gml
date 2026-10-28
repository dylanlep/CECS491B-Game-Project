/// obj_friends_menu - Draw

// Dim the hub behind the panel
draw_set_alpha(0.75);
draw_set_color(c_black);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1);

// Panel
draw_sprite_stretched(spr_ui_box, 0, px, py, pw, ph);
draw_set_font(fnt_pixel);
draw_set_valign(fa_middle);

// Title
draw_set_halign(fa_center);
draw_set_color(c_aqua);
draw_text(room_width / 2, py + 10, "FRIENDS");

// Tabs
for (var i = 0; i < 3; i++) {
    ui_button_draw(tab_x[i], tab_y, tab_w[i], tab_h, tab_label[i], i == tab || i == hover_tab);
}
draw_set_font(fnt_pixel);
draw_set_valign(fa_middle);

if (tab == 0) {
    // --- ADD ---
    draw_set_halign(fa_center);
    draw_set_color(c_white);
    draw_text(room_width / 2, box_y - 10, "TYPE YOUR FRIEND'S USERNAME");

    draw_sprite_stretched(spr_ui_box_focus, 0, box_x, box_y, box_w, box_h);
    draw_set_halign(fa_left);
    draw_set_color(c_yellow);
    var _cursor = ((current_time div 500) mod 2 == 0) ? "_" : "";
    draw_text(box_x + 6, box_y + box_h / 2, typed + _cursor);

    ui_button_draw(send_x, send_y, send_w, send_h, send_label, hover_send);
    draw_set_font(fnt_pixel);
    draw_set_valign(fa_middle);

    if (global.friends_my_name != "") {
        draw_set_halign(fa_center);
        draw_set_color(c_ltgray);
        draw_text(room_width / 2, send_y + 30, "YOUR USERNAME: " + string_upper(global.friends_my_name));
    }
} else {
    // --- REQUESTS / FRIENDS lists ---
    draw_set_halign(fa_center);
    draw_set_color(c_ltgray);
    if (!global.friends_loaded) {
        draw_text(room_width / 2, list_y + 30, "LOADING...");
    } else if (array_length(rows) == 0) {
        draw_text(room_width / 2, list_y + 30, (tab == 1) ? "NO REQUESTS" : "NO FRIENDS YET - ADD SOME!");
    }

    draw_set_halign(fa_left);
    for (var r = 0; r < min(array_length(rows), max_rows); r++) {
        var _row  = rows[r];
        var _y    = list_y + r * row_step + row_h / 2;
        var _name = string_upper(string_copy(_row.name, 1, 12));
        switch (_row.kind) {
            case "in":  draw_set_color(c_yellow); draw_text(px + 10, _y, _name);           break;
            case "out": draw_set_color(c_ltgray); draw_text(px + 10, _y, "SENT: " + _name); break;
            default:    draw_set_color(c_white);  draw_text(px + 10, _y, _name + "  " + string(_row.xp) + " XP"); break;
        }
    }
    if (array_length(rows) > max_rows) {
        draw_set_halign(fa_center);
        draw_set_color(c_ltgray);
        draw_text(room_width / 2, list_y + max_rows * row_step + 2, "+" + string(array_length(rows) - max_rows) + " MORE");
    }

    for (var b = 0; b < array_length(btns); b++) {
        var _b = btns[b];
        ui_button_draw(_b.x, _b.y, _b.w, row_h, _b.label, b == hover_btn);
    }
}

// Server answer
draw_set_font(fnt_pixel);
draw_set_valign(fa_middle);
if (global.friends_message != "") {
    draw_set_halign(fa_center);
    draw_set_color(c_yellow);
    draw_text(room_width / 2, msg_y, global.friends_message);
}

// CLOSE
ui_button_draw(close_x, close_y, close_w, close_h, close_label, hover_close);

// Reset so other objects aren't affected
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);