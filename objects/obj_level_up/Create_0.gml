/// obj_level_up - Create
// Pop-up shown when the player reaches a new level.
// Made by level_up_show() (scr_player_progress). NICE! / Enter / Space / Esc closes it.

old_level = 1;   // set by level_up_show()
new_level = 2;
timer     = 0;   // frames since it opened; drives the animations

// Panel
pw = 216;
ph = 128;
px = (room_width  - pw) / 2;
py = (room_height - ph) / 2;

// XP bar toward the next level (fills up after the panel opens)
bar_w    = 160;
bar_h    = 8;
bar_x    = (room_width - bar_w) / 2;
bar_y    = py + 62;
bar_fill = 0;

// NICE! button
btn_label = "NICE!";
btn_w = ui_button_width(btn_label);
btn_h = 16;
btn_x = (room_width - btn_w) / 2;
btn_y = py + ph - btn_h - 12;
hovered = false;

// Ignore input briefly: the player may still be clicking CONTINUE when this appears
ignore_frames = 20;