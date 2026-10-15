/// obj_shop - Create
// In-game Shop (SCRUM-29): spend coins on avatars, themes and items.

// --- Wallet and owned items (globals, so they survive room changes) ---
if (!variable_global_exists("coins"))      global.coins = 0;
if (!variable_global_exists("shop_owned")) global.shop_owned = {};   // e.g. { ROBOT: true }

// --- Shop catalog: tab number, name, price ---
tabs = ["AVATARS", "THEMES", "ITEMS"];
items = [
    { tab: 0, name: "ROBOT",     price: 20 },
    { tab: 0, name: "NINJA",     price: 40 },
    { tab: 0, name: "WIZARD",    price: 60 },
    { tab: 1, name: "DARK",      price: 30 },
    { tab: 1, name: "RETRO",     price: 50 },
    { tab: 1, name: "OCEAN",     price: 50 },
    { tab: 2, name: "HINT PACK", price: 10 },
    { tab: 2, name: "XP BOOST",  price: 40 },
    { tab: 2, name: "SHIELD",    price: 60 },
];
current_tab = 0;

// --- Layout (256 x 240 room) ---
tab_h = 16;
tab_y = 24;
tab_gap = 6;
tab_x = [];
tab_w = [];
var _row_w = 0;
for (var i = 0; i < array_length(tabs); i++) _row_w += ui_button_width(tabs[i]);
_row_w += tab_gap * (array_length(tabs) - 1);
var _x = (room_width - _row_w) / 2;
for (var i = 0; i < array_length(tabs); i++) {
    array_push(tab_x, _x);
    array_push(tab_w, ui_button_width(tabs[i]));
    _x += ui_button_width(tabs[i]) + tab_gap;
}

row_y0  = 56;     // first item row
row_gap = 28;     // distance between rows
buy_h   = 18;
buy_w   = ui_button_width("OWNED");                 // fits BUY and OWNED
buy_x   = room_width - buy_w - 8;

back_label = "BACK";
back_w = ui_button_width(back_label);
back_h = 16;
back_x = room_width  - back_w - 4;
back_y = room_height - back_h - 4;

// --- Hover state (set every frame in Step) ---
hover_tab  = -1;
hover_row  = -1;
hover_back = false;

message_text  = "";
message_color = c_yellow;