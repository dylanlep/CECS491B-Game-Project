/// obj_friends_menu - Step

if (ignore_clicks > 0) { ignore_clicks--; keyboard_string = ""; exit; }
var _click = mouse_check_button_pressed(mb_left);

// --- CLOSE (button or Esc) ---
hover_close = ui_mouse_over(close_x, close_y, close_w, close_h);
if ((hover_close && _click) || keyboard_check_pressed(vk_escape)) {
    keyboard_string = "";
    instance_destroy();
    exit;
}

// --- Tabs (labels show how many requests / friends there are) ---
var _n_in  = array_length(global.friend_requests_in);
var _n_out = array_length(global.friend_requests_out);
var _n_fr  = array_length(global.friends);
tab_label[1] = "REQUESTS (" + string(_n_in) + ")";
tab_label[2] = "FRIENDS (" + string(_n_fr) + ")";

var _gap   = 4;
var _total = _gap * 2;
for (var i = 0; i < 3; i++) { tab_w[i] = ui_button_width(tab_label[i]); _total += tab_w[i]; }
var _tx = (room_width - _total) / 2;
hover_tab = -1;
for (var i = 0; i < 3; i++) {
    tab_x[i] = _tx;
    _tx += tab_w[i] + _gap;
    if (ui_mouse_over(tab_x[i], tab_y, tab_w[i], tab_h)) {
        hover_tab = i;
        if (_click && tab != i) {
            tab = i;
            confirm_id = -1;
            keyboard_string = typed;
            _click = false;     // this click only switched tabs
        }
    }
}

// --- ADD tab: type a username, SEND REQUEST (or Enter) ---
if (tab == 0) {
    typed = string_copy(keyboard_string, 1, 20);
    keyboard_string = typed;
    hover_send = ui_mouse_over(send_x, send_y, send_w, send_h);
    if ((hover_send && _click) || keyboard_check_pressed(vk_enter)) {
        friends_send(typed);
    }
    exit;
}

// --- REQUESTS / FRIENDS tabs: build the rows ---
rows = [];
if (tab == 1) {
    for (var i = 0; i < _n_in; i++) {
        var _r = global.friend_requests_in[i];
        array_push(rows, { kind: "in", id: _r.id, name: _r.name, xp: 0 });
    }
    for (var i = 0; i < _n_out; i++) {
        var _r = global.friend_requests_out[i];
        array_push(rows, { kind: "out", id: _r.id, name: _r.name, xp: 0 });
    }
} else {
    for (var i = 0; i < _n_fr; i++) {
        var _r = global.friends[i];
        array_push(rows, { kind: "friend", id: _r.id, name: _r.name, xp: _r.xp });
    }
}

// --- Buttons on each row (right side) ---
btns = [];
var _right = px + pw - 8;
for (var r = 0; r < min(array_length(rows), max_rows); r++) {
    var _row = rows[r];
    var _y   = list_y + r * row_step;
    var _labels, _acts;
    switch (_row.kind) {
        case "in":  _labels = ["ACCEPT", "NO"]; _acts = ["accept", "decline"]; break;
        case "out": _labels = ["CANCEL"];       _acts = ["cancel"];            break;
        default:    _labels = [(confirm_id == _row.id) ? "SURE?" : "REMOVE"]; _acts = ["remove"]; break;
    }
    var _bx = _right;
    for (var b = array_length(_labels) - 1; b >= 0; b--) {
        var _bw = ui_button_width(_labels[b]);
        _bx -= _bw;
        array_push(btns, { x: _bx, y: _y, w: _bw, label: _labels[b], act: _acts[b], id: _row.id });
        _bx -= 4;
    }
}

// --- Clicks on row buttons ---
hover_btn = -1;
for (var b = 0; b < array_length(btns); b++) {
    var _b = btns[b];
    if (ui_mouse_over(_b.x, _b.y, _b.w, row_h)) {
        hover_btn = b;
        if (_click) {
            switch (_b.act) {
                case "accept":  friends_accept(_b.id);  break;
                case "decline": friends_decline(_b.id); break;
                case "cancel":  friends_remove(_b.id);  break;
                case "remove":                                   // SCRUM-39: two clicks to remove
                    if (confirm_id == _b.id) { friends_remove(_b.id); confirm_id = -1; }
                    else confirm_id = _b.id;
                    break;
            }
        }
    }
}