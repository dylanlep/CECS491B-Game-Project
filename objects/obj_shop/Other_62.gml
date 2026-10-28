/// obj_shop - Step

progress_init();

// SCRUM-47: freeze the shop while the cheat pop-up is open
if (instance_exists(obj_cheat_popup)) exit;

// SCRUM-47: did a purchase answer just arrive from the server?
if (global.progress_buy_result != "") {
    var _name = global.progress_buy_item;
    switch (global.progress_buy_result) {
        case "bought": message_text = "BOUGHT " + _name + "!";      message_color = c_lime;   break;
        case "owned":  message_text = "YOU ALREADY OWN " + _name;   message_color = c_yellow; break;
        case "poor":   message_text = "NOT ENOUGH COINS";           message_color = c_red;    break;
        case "cheat":  message_text = "";                                                     break;
        default:       message_text = "PURCHASE FAILED, TRY AGAIN"; message_color = c_red;    break;
    }
    global.progress_buy_result = "";
}

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

// --- BUY buttons (the purchase itself happens on the server, via scr_player_progress) ---
hover_row = -1;
for (var r = 0; r < array_length(_visible); r++) {
    var _y = row_y0 + r * row_gap;
    if (ui_mouse_over(buy_x, _y, buy_w, buy_h)) {
        hover_row = r;
        if (_click) {
            var _item = items[_visible[r]];
            switch (progress_buy(_item.name, _item.price)) {
                case "owned":   message_text = "YOU ALREADY OWN " + _item.name;  message_color = c_yellow; break;
                case "poor":    message_text = "NOT ENOUGH COINS";              message_color = c_red;    break;
                case "pending": message_text = "BUYING " + _item.name + "...";  message_color = c_white;  break;
                case "busy":    message_text = "PLEASE WAIT...";                message_color = c_white;  break;
                case "cheat":   message_text = "";                                                        break;
                default:        message_text = "PURCHASE FAILED, TRY AGAIN";    message_color = c_red;    break;
            }
        }
    }
}

// --- BACK ---
hover_back = ui_mouse_over(back_x, back_y, back_w, back_h);
if (hover_back && _click) room_goto(rm_mode_hub);