/// obj_game - Create Event

gpu_set_texfilter(false); // crisp pixel scaling, no blur

// ---------- Account settings ----------
account_open = false;
account_active_field = 0; // 0 = none, 1 = email, 2 = password
account_email_input = "";
account_password_input = "";
account_message = "";
account_request_id = -1;
account_busy = false;
account_pending_email_change = false;

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


// -------- Connection to Language menu ---------

if (variable_global_exists("current_lesson_language") && global.current_lesson_language != "None") {
    for (var i = 0; i < lesson_count; i++) {
        if (lesson_names[i] == global.current_lesson_language) {
            current_lesson = i;
            break;
        }
    }
} else {
    //default to C
    current_lesson = 1;
}

// ---------- Score (XP), one per language, like Duolingo ----------
language_scores[0] = 0;
language_scores[1] = 0;
language_scores[2] = 0;

base_xp          = 10; // XP for a perfect first-try correct answer
mistake_penalty  = 2;  // XP lost per wrong Check attempt before getting it right
min_xp           = 2;  // floor — a messy correct answer still earns something

mistake_count = 0; // wrong Check presses on the CURRENT round only
feedback_is_hint = false;

// ---------- Level Complete screen ----------
level_complete_open = false;
lc_xp       = 0;   // XP earned this level
lc_coins    = 0;   // coins earned this level
lc_mistakes = 0;
lc_streak   = 0;
lc_lang     = "";
lc_hover    = -1;  // 0 = CONTINUE, 1 = MENU

lc_btn_label = ["CONTINUE", "MENU"];
lc_btn_h = 16;
lc_btn_y = 196;
lc_btn_w = [ui_button_width(lc_btn_label[0]), ui_button_width(lc_btn_label[1])];
var _lc_gap   = 8;
var _lc_row_w = lc_btn_w[0] + _lc_gap + lc_btn_w[1];
lc_btn_x = [(room_width - _lc_row_w) / 2, 0];
lc_btn_x[1] = lc_btn_x[0] + lc_btn_w[0] + _lc_gap;

// ---------- Build the first lesson ----------
scr_setup_lesson();
