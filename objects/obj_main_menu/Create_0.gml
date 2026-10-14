/// obj_main_menu - Create
// Title screen: game name + START + SETTINGS.

title_text = "BINARY BRAINS";

// Button labels, top to bottom
buttons  = ["START", "SETTINGS"];
selected = 0;          // which button is highlighted (0 = START)

// Layout: all buttons share one width (the widest label) so they line up
btn_height  = 18;
btn_spacing = 8;       // gap between buttons
btn_width   = 0;
for (var i = 0; i < array_length(buttons); i++) {
    btn_width = max(btn_width, ui_button_width(buttons[i]));
}
btn_width = max(btn_width, 96);              // never narrower than 96 px
btn_x  = (room_width - btn_width) / 2;       // centered
btn_y0 = 120;                                // top of the first button

message_text = "";     // e.g. "SETTINGS COMING SOON"