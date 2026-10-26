/// scr_build_board()
/// Python tab (index 0) uses the level system. C and Java use the old lesson.

function scr_build_board() {
    if (current_lesson == 0) {
        scr_setup_level();
    } else {
        scr_setup_lesson();
    }
}