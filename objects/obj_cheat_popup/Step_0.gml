/// obj_cheat_popup - Step

flash_timer++;
if (shake_timer > 0) shake_timer--;

// Typing effect
shown_chars = min(shown_chars + type_speed, string_length(message));

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// "NO I'M NOT" runs away whenever the mouse gets close
var _nope_cx = nope_x + nope_w / 2;
var _nope_cy = nope_y + btn_h / 2;
if (point_distance(_mx, _my, _nope_cx, _nope_cy) < 30) {
    repeat (10) {   // try a few random spots, keep one that's far from the mouse
        nope_x = irandom_range(panel_x + 4, panel_x + panel_w - nope_w - 4);
        nope_y = irandom_range(panel_y + 18, panel_y + panel_h - btn_h - 4);
        if (point_distance(_mx, _my, nope_x + nope_w / 2, nope_y + btn_h / 2) > 50) break;
    }
}

// "I'M SORRY" closes the pop-up (mouse or Enter)
hover_sorry = point_in_rectangle(_mx, _my, sorry_x, sorry_y, sorry_x + sorry_w, sorry_y + btn_h);
if ((hover_sorry && mouse_check_button_pressed(mb_left)) || keyboard_check_pressed(vk_enter)) {
    instance_destroy();
}