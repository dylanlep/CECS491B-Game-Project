/// obj_game - Create Event

// ---------- Lesson data for each language ----------
lesson_tokens[0] = ["print", "(", "\"Hello, world!\"", ")", ";"];              // Python
lesson_tokens[1] = ["printf", "(", "\"Hello, world!\"", ")", ";"];             // C
lesson_tokens[2] = ["System.out.println", "(", "\"Hello, world!\"", ")", ";"]; // Java
 
lesson_names[0] = "Python";
lesson_names[1] = "C";
lesson_names[2] = "Java";

lesson_count   = array_length(lesson_names);
current_lesson = 1; // start on C

// ---------- Language button layout ----------
lang_button_width   = 160;
lang_button_height  = 50;
lang_button_spacing = 20;
lang_button_y       = 110;

var total_w = lesson_count * (lang_button_width + lang_button_spacing) - lang_button_spacing;
var start_x = (room_width - total_w) / 2;

for (var i = 0; i < lesson_count; i++) {
    lang_button_x[i] = start_x + i * (lang_button_width + lang_button_spacing);
}

// ---------- Build the first lesson ----------
scr_setup_lesson();