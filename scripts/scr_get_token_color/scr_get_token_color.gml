/// scr_get_token_color(_category)
/// Central color table — modeled on VS Code's Dark+ theme colors, so each
/// category reads the same way it would in a real editor.

function scr_get_token_color(_category) {
    switch (_category) {
        case "keyword":     return make_color_rgb(197, 134, 192); // if/else/for/while/return — pink-purple
        case "type":        return make_color_rgb(78, 201, 176);  // var/int/bool/string — teal
        case "string":      return make_color_rgb(206, 145, 120); // "Hello, world!" — orange
        case "punctuation": return make_color_rgb(212, 212, 212); // ( ) ; , — light gray
        case "identifier":  return make_color_rgb(220, 220, 170); // printf/println — soft yellow
        default:            return c_white;
    }
}