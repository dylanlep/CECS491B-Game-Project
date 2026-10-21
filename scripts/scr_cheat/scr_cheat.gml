/// scr_cheat
/// SCRUM-47: the comedic "cheat detected" pop-up.
/// To add or change jokes, edit the messages below. Nothing else needs to change.

/// Random jokes for a first attempt (no name used yet).
function cheat_first_messages() {
    return [
        "NICE TRY, HACKER.\nTHE ROBOTS SAW EVERYTHING.",
        "ERROR 404:\nYOUR HONESTY WAS NOT FOUND.",
        "if (cheating) {\n    coins = 0; // lol\n}",
        "YOUR COINS HAVE BEEN\nSENT TO THE RECYCLE BIN.",
        "SYNTAX ERROR:\nUNEXPECTED SHENANIGANS\nON LINE 1.",
        "THE DEBUGGER FOUND A BUG.\nTHE BUG IS YOU.",
        "CTRL + Z.\nYOUR CHEAT HAS BEEN UNDONE."
    ];
}

/// The message for this attempt number (1 = first time), using the player's name.
function cheat_message(_attempt, _name) {
    var _n = string_upper(string_copy(_name, 1, 12));   // max 12 letters, in capitals
    if (_n == "") _n = "PLAYER";

    switch (_attempt) {
        case 1:
            var _list = cheat_first_messages();
            return _list[irandom(array_length(_list) - 1)];
        case 2:  return _n + ". NOT AGAIN.\nTHE ROBOTS ARE GETTING TIRED.";
        case 3:  return _n + ", THE ROBOTS HAVE STARTED\nA GROUP CHAT ABOUT YOU.";
        case 4:  return _n + "... SERIOUSLY?\nTHIS IS ATTEMPT #4.";
        default: return "INFINITE LOOP DETECTED:\nwhile (" + _n + ") cheat();";
    }
}

/// Shows the pop-up (only one at a time).
function cheat_popup_show(_attempt, _name) {
    if (instance_exists(obj_cheat_popup)) return;
    var _popup = instance_create_depth(0, 0, -20000, obj_cheat_popup);
    _popup.message = cheat_message(_attempt, _name);
}