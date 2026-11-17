/// obj_reset_button - Create
// SCRUM-58: RESET button in the lesson. Sends every block back to the bank.
// Its position comes from obj_game (set in scr_setup_lesson, left of HINT).

hovered = false;

/// True while something covers the lesson (then RESET hides and ignores clicks).
/// Works before and after Dylan H's pause / level-complete screens are merged.
is_frozen = function() {
    if (!instance_exists(obj_game)) return true;
    var _g = instance_find(obj_game, 0);
    if (_g.account_open) return true;
    if (variable_instance_exists(_g, "level_complete_open")   && _g.level_complete_open)   return true;
    if (variable_instance_exists(_g, "pause_open")            && _g.pause_open)            return true;
    if (variable_instance_exists(_g, "pause_settings_active") && _g.pause_settings_active) return true;
    return false;
};