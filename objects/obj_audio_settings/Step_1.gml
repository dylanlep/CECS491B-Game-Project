/// obj_audio_settings - Begin Step
// Handles input BEFORE everything else, then clears it,
// so the title screen behind the panel doesn't react.

if (ignore_frames > 0) { ignore_frames--; io_clear(); exit; }

var _click = mouse_check_button_pressed(mb_left);

// --- Keyboard ---
if (keyboard_check_pressed(vk_escape)) { close(); exit; }
if (keyboard_check_pressed(vk_down))  row = (row + 1) mod row_count;
if (keyboard_check_pressed(vk_up))    row = (row - 1 + row_count) mod row_count;
if (keyboard_check_pressed(vk_left)  && row < 2) change(row, -0.1);
if (keyboard_check_pressed(vk_right) && row < 2) change(row,  0.1);
if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
    if (row == 2) toggle_mute();
    if (row == 3) { close(); exit; }
}

// --- Mouse ---
hover = "";
for (var r = 0; r < 2; r++) {
    var _y = row_y[r];
    if (ui_mouse_over(minus_x, _y, btn_s, 16)) { hover = "minus" + string(r); if (_click) { row = r; change(r, -0.1); } }
    if (ui_mouse_over(plus_x,  _y, btn_s, 16)) { hover = "plus"  + string(r); if (_click) { row = r; change(r,  0.1); } }
    if (ui_mouse_over(bar_x,   _y, bar_w, 16)) { hover = "bar"   + string(r); if (_click) { row = r; set_from_bar(r, mouse_x); } }
}
if (ui_mouse_over(minus_x, row_y[2], mute_w, 16)) { hover = "mute"; if (_click) { row = 2; toggle_mute(); } }
if (ui_mouse_over(back_x, back_y, back_w, back_h)) { hover = "back"; if (_click) { close(); exit; } }

io_clear();