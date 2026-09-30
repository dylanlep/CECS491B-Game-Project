/// obj_game - Create Event

gpu_set_texfilter(false); // crisp pixel scaling, no blur

// ---------- Lesson data for each language ----------
lesson_tokens[0] = ["print", "(", "\"Hello, world!\"", ")", ";"];              // Python
lesson_tokens[1] = ["printf", "(", "\"Hello, world!\"", ")", ";"];             // C
lesson_tokens[2] = ["System.out.println", "(", "\"Hello, world!\"", ")", ";"]; // Java

lesson_names[0] = "Python";
lesson_names[1] = "C";
lesson_names[2] = "Java";

lesson_count   = array_length(lesson_names);
current_lesson = 1; // start on C

// ---------- Language tab layout ----------
lang_button_width   = 70;
lang_button_height  = 14;
lang_button_spacing = 4;
lang_button_y       = 4;

var total_w = lesson_count * (lang_button_width + lang_button_spacing) - lang_button_spacing;
var start_x = (room_width - total_w) / 2;

for (var i = 0; i < lesson_count; i++) {
    lang_button_x[i] = start_x + i * (lang_button_width + lang_button_spacing);
}

// ---------- Shared layout constants used by scr_setup_lesson ----------
row_height   = 26;  // height of every slot AND every bank chip
row_spacing  = 4;   // vertical gap between wrapped rows
chip_spacing = 4;   // horizontal gap between chips in the same row
chip_padding = 12;  // extra width added to a token's raw text width
side_margin  = 10;  // left/right margin for both the slot area and bank area

slot_area_y_start = lang_button_y + lang_button_height + 8;

// ---------- Build the first lesson ----------
scr_setup_lesson();