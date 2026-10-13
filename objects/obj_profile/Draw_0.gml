/// obj_profile - Draw Event

// Semi-transparent background overlay
draw_set_color(c_black);
draw_set_alpha(0.6);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1.0);

// Main profile panel background
draw_set_color(c_gray);
draw_rectangle(panel_x, panel_y, panel_x + panel_width, panel_y + panel_height, false);
draw_set_color(c_white);
draw_rectangle(panel_x, panel_y, panel_x + panel_width, panel_y + panel_height, true);

// Header title
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_yellow);
draw_text(room_width/2, panel_y + 20, "User Profile");

// Profile Details (Left-aligned labels, right-aligned data or neatly stacked)
draw_set_halign(fa_left);
var label_x = panel_x + 30;
var start_y = panel_y + 80;
var spacing = 45;

draw_set_color(c_gray);
draw_text(label_x, start_y, "Username:");
draw_set_color(c_white);
draw_text(label_x + 120, start_y, display_username);

draw_set_color(c_gray);
draw_text(label_x, start_y + spacing, "Email:");
draw_set_color(c_white);
// Truncate email string visually if it's too long for the box
draw_text(label_x + 120, start_y + spacing, display_email);

draw_set_color(c_gray);
draw_text(label_x, start_y + (spacing * 2), "User ID:");
draw_set_color(c_white);
// Show truncated UUID for clean layout formatting
var short_id = (string_length(display_id) > 16) ? string_copy(display_id, 1, 16) + "..." : display_id;
draw_text(label_x + 120, start_y + (spacing * 2), short_id);

// Back / Close Button
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_red);
draw_rectangle(btn_x, btn_y, btn_x + btn_width, btn_y + btn_height, false);
draw_set_color(c_black);
draw_rectangle(btn_x, btn_y, btn_x + btn_width, btn_y + btn_height, true);
draw_set_color(c_white);
draw_text(btn_x + btn_width/2, btn_y + btn_height/2, "Back to Menu");

// Reset alignments
draw_set_halign(fa_left);
draw_set_valign(fa_top);