/// obj_block - Create Event

word_text     = "word";
block_width   = 60;
block_height  = 20;
home_x        = x;
home_y        = y;
current_slot  = -1;
correct_index = 0;

token_category = "identifier"; // overwritten right after spawn
base_color     = c_white;      // overwritten right after spawn

dragging   = false;
drag_off_x = 0;
drag_off_y = 0;

// ---------- Hover bounce ----------
is_hovered    = false;
display_scale = 1;
hover_scale   = 1.15;
hover_ease    = 0.25;

// ---------- Pixel border ----------
border_thickness = 2;

depth = 0;