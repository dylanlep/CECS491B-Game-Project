/// obj_shop - Step

// Which items belong to the current tab?
var _visible = [];
for (var i = 0; i < array_length(items); i++) {
    if (items[i].tab == current_tab) array_push(_visible, i);
}

var _click = mouse_check_button_pressed(mb_left);

// --- Keyboard: left/right arrows switch tabs ---
if (keyboard_check_pressed(vk_right)) { current_tab = (current_tab + 1) mod array_length(tabs); message_text = ""; }
if (keyboard_check_pressed(vk_left))  { current_tab = (current_tab - 1 + array_length(tabs)) mod array_length(tabs); message_text = ""; }

// --- Tabs ---
hover_tab = -1;
for (var i = 0; i < array_length(tabs); i++) {
    if (ui_mouse_over(tab_x[i], tab_y, tab_w[i], tab_h)) {
        hover_tab = i;
        if (_click) { current_tab = i; message_text = ""; }
    }
}

// --- BUY buttons (the purchase itself happens in scr_player_progress) ---
hover_row = -1;
for (var r = 0; r < array_length(_visible); r++) {
    var _y = row_y0 + r * row_gap;
    if (ui_mouse_over(buy_x, _y, buy_w, buy_h)) {
        hover_row = r;
        if (_click) {
            var _item = items[_visible[r]];
            switch (progress_buy(_item.name, _item.price)) {
                case "owned":
                    message_text  = "YOU ALREADY OWN " + _item.name;
                    message_color = c_yellow;
                    break;
                case "poor":
                    message_text  = "NOT ENOUGH COINS";
                    message_color = c_red;
                    break;
                case "bought":
                    message_text  = "BOUGHT " + _item.name + "!";
                    message_color = c_lime;
                    break;
            }
        }
    }
}

// --- BACK ---
hover_back = ui_mouse_over(back_x, back_y, back_w, back_h);
if (hover_back && _click) room_goto(rm_mode_hub);