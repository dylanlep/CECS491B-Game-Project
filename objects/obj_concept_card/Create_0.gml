/// obj_concept_card - Create
// SCRUM-49: concept card shown before a Python level.
// GOT IT! (or Enter / Space) closes it.

card = { title: "", text: "", example: "", output: "" };   // filled in by concept_card_check()

// Panel
px = 16;
py = 20;
pw = room_width  - 32;
ph = room_height - 40;

// GOT IT! button
btn_label = "GOT IT!";
btn_w = ui_button_width(btn_label);
btn_h = 16;
btn_x = (room_width - btn_w) / 2;
btn_y = py + ph - btn_h - 8;
hovered = false;

ignore_frames = 2;   // the click that finished the last level shouldn't close the card at once