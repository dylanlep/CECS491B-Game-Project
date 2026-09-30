/// obj_logout_button - Create
// Small "LOGOUT" button in the bottom-right corner of rm_lesson (256x240).

draw_set_font(fnt_pixel);
btn_width  = string_width("LOGOUT") + 16;   // fit the text + padding
btn_height = 16;
btn_x1 = room_width  - btn_width  - 4;      // 4 px from the right edge
btn_y1 = room_height - btn_height - 4;      // 4 px from the bottom edge
btn_x2 = btn_x1 + btn_width;
btn_y2 = btn_y1 + btn_height;

logout_request_id = -1;     // ID of the Supabase answer we're waiting for
is_logging_out    = false;  // true while waiting, so extra clicks are ignored