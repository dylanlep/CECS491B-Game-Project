/// scr_build_board()
/// Build a Python level or the legacy lesson board.

function scr_build_board() {
    held_block = noone;
    if (current_lesson == 0) {
        scr_setup_level();
    } else {
        scr_setup_lesson();
    }
}
