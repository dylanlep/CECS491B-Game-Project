/// scr_classify_token(_word)
/// Returns a category name: "keyword", "type", "string", "punctuation",
/// or "identifier" (fallback — function/variable names).

function scr_classify_token(_word) {

    if (string_length(_word) >= 2
    && string_char_at(_word, 1) == "\""
    && string_char_at(_word, string_length(_word)) == "\"") {
        return "string";
    }

    var punctuation = ["(", ")", ";", ",", ".", "{", "}", "[", "]"];
    for (var i = 0; i < array_length(punctuation); i++) {
        if (_word == punctuation[i]) return "punctuation";
    }

    var keywords = ["if", "else", "for", "while", "return", "break", "continue"];
    for (var i = 0; i < array_length(keywords); i++) {
        if (_word == keywords[i]) return "keyword";
    }

    var types = ["var", "int", "bool", "float", "string", "double", "char", "void"];
    for (var i = 0; i < array_length(types); i++) {
        if (_word == types[i]) return "type";
    }

    return "identifier";
}