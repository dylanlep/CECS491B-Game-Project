/// obj_cheat_popup - Create
// Comedic "cheat detected" pop-up (SCRUM-47). Covers the whole screen.
display_set_gui_size(room_width, room_height);   // GUI uses the 256x240 game size, not the window size
message     = "";      // set by cheat_popup_show() right after creation
shown_chars = 0;       // typing effect: how many letters are visible
type_speed  = 0.6;     // letters per frame

shake_timer = 30;      // frames of screen shake at the start
flash_timer = 0;       // makes the banner blink

// Panel layout (256 x 240 game screen)
panel_x = 12;
panel_y = 40;
panel_w = 232;
panel_h = 150;

// Buttons
btn_h = 16;
sorry_label = "I'M SORRY";
sorry_w = ui_button_width(sorry_label);
sorry_x = panel_x + 16;
sorry_y = panel_y + panel_h - btn_h - 10;

nope_label = "NO I'M NOT";
nope_w = ui_button_width(nope_label);
nope_x = panel_x + panel_w - nope_w - 16;
nope_y = sorry_y;

hover_sorry = false;