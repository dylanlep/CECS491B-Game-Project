/// obj_concept_card - Begin Step
// Runs BEFORE every other object's Step, then clears the input,
// so nothing behind the card (blocks, CHECK, menus) reacts while it is open.

// The LEVEL UP pop-up sits on top and takes the input first; wait until it closes
if (instance_exists(obj_level_up)) { hovered = false; exit; }

hovered = ui_mouse_over(btn_x, btn_y, btn_w, btn_h);

if (ignore_frames > 0) {
    ignore_frames--;
} else if ((hovered && mouse_check_button_pressed(mb_left))
        || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
    io_clear();
    instance_destroy();
    exit;
}

io_clear();