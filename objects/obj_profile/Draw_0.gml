/// obj_profile - Draw Event

draw_set_font(fnt_pixel);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Title header (scaled up slightly)
draw_set_color(c_white);
draw_text_transformed(room_width / 2, 70, "USER PROFILE", 3, 3, 0);

// Larger profile info box background (960 x 560)
var box_w = 960;
var box_h = 560;
var box_x = (room_width - box_w) / 2;
var box_y = 110;

draw_sprite_stretched(spr_ui_box, 0, box_x, box_y, box_w, box_h);

// Display user details inside the box with larger text
draw_set_halign(fa_left);
var text_x = box_x + 80;
var scale = 2; // Makes text larger

var _username = (variable_global_exists("username")) ? global.username : "Player";
var _email = (variable_global_exists("user_email")) ? global.user_email : "Unknown";

draw_text_transformed(text_x, box_y + 110, "Username: " + string(_username), scale, scale, 0);
draw_text_transformed(text_x, box_y + 130, "Email: " + string(_email), scale, scale, 0);
draw_text_transformed(text_x, box_y + 170, "Level: 1", scale, scale, 0);
draw_text_transformed(text_x, box_y + 190, "XP: 0/100", scale, scale, 0);
draw_text_transformed(text_x, box_y + 230, "Coins: 0", scale, scale, 0);
draw_text_transformed(text_x, box_y + 250, "Streak: 0", scale, scale, 0);


// Buttons Container (Placed side-by-side or stacked below the box)
var btn_w = 260;
var btn_h = 56;
var btn_y = box_y + box_h + 20; // Positioned cleanly just under the main box

// 1. Edit Account Button (Left side)
var edit_btn_x = room_width / 2 - btn_w - 20;
draw_sprite_stretched(spr_ui_box, 0, edit_btn_x, btn_y, btn_w, btn_h);
draw_set_halign(fa_center);
draw_text_transformed(edit_btn_x + btn_w / 2, btn_y + btn_h / 2, "EDIT ACCOUNT", 1.2, 1.2, 0);

// 2. Log Out Button (Right side)
var logout_btn_x = room_width / 2 + 20;
draw_sprite_stretched(spr_ui_box, 0, logout_btn_x, btn_y, btn_w, btn_h);
draw_set_halign(fa_center);
draw_text_transformed(logout_btn_x + btn_w / 2, btn_y + btn_h / 2, "LOG OUT", 1.2, 1.2, 0);

// Reset alignment/scale defaults
draw_set_halign(fa_left);
draw_set_valign(fa_top);