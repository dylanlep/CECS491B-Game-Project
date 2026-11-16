/// scr_concept_cards - SCRUM-49
/// Short concept cards shown before Python levels (e.g. "print() shows a message on the screen").
///
/// TO ADD A CARD: add one concept_card_add(...) line in concept_cards_init(),
/// and, if needed, a rule in concept_card_key() that says which token it explains.

/// Adds one card to the list.
function concept_card_add(_key, _title, _text, _example, _output) {
    variable_struct_set(global.concept_cards, _key, {
        title:   _title,     // big heading
        text:    _text,      // 1-3 short sentences
        example: _example,   // example code
        output:  _output     // what the example shows on screen
    });
}

/// Builds the card list once per game session.
function concept_cards_init() {
    if (variable_global_exists("concept_cards")) return;
    global.concept_cards = {};
    global.concept_seen  = {};   // cards already shown this session

    concept_card_add("print",
        "print()",
        "print() shows a message on the screen. Put the message inside the ( ).",
        "print(\"Hi!\")",
        "Hi!");

    concept_card_add("parens",
        "PARENTHESES ( )",
        "( ) hold what a command needs. print( ) needs the message it should show.",
        "print(\"Bye\")",
        "Bye");

    concept_card_add("strings",
        "STRINGS \" \"",
        "Text inside quotes is called a string. The quotes show where the text starts and ends.",
        "print(\"Hello, world!\")",
        "Hello, world!");
}

/// Which card (if any) explains this token? "" = none.
function concept_card_key(_token) {
    if (_token == "print")                      return "print";
    if (_token == "(" || _token == ")")         return "parens";
    if (scr_classify_token(_token) == "string") return "strings";
    return "";
}

/// Called by scr_setup_lesson (inside obj_game) before each level.
/// Python only: shows the first card this level needs that hasn't been shown yet.
function concept_card_check() {
    concept_cards_init();
    if (lesson_names[current_lesson] != "Python") return;
    if (instance_exists(obj_concept_card)) return;

    for (var i = 0; i < array_length(correct_answer); i++) {
        var _key = concept_card_key(correct_answer[i]);
        if (_key == "") continue;
        if (!variable_struct_exists(global.concept_cards, _key)) continue;
        if (variable_struct_exists(global.concept_seen, _key)) continue;

        variable_struct_set(global.concept_seen, _key, true);
        var _card = instance_create_depth(0, 0, -15000, obj_concept_card);
        _card.card = variable_struct_get(global.concept_cards, _key);
        return;
    }
}