/// obj_audio_settings - Create
// SCRUM-52: basic settings screen (audio), opened from the title screen's SETTINGS.
// Mouse: - / + buttons, click the bar, MUTE, BACK.  Keys: up/down pick, left/right change, Enter, Esc.

audio_settings_init();
depth = -10000;
ignore_frames = 2;       // the click that opened the panel shouldn't press anything

row       = 0;           // 0 = MUSIC, 1 = SOUND FX, 2 = MUTE ALL, 3 = BACK
row_count = 4;
hover     = "";          // what the mouse is over

// Panel
px = 24;
py = 40;
pw = room_width - 48;
ph = 160;

// Rows
row_label = ["MUSIC", "SOUND FX", "MUTE ALL"];
row_y     = [py + 40, py + 64, py + 88];   // top of each row (16 px tall)
label_x   = px + 10;
btn_s     = 14;                            // size of the - and + buttons
minus_x   = px + 78;
bar_x     = minus_x + btn_s + 4;
bar_w     = 56;
bar_h     = 8;
plus_x    = bar_x + bar_w + 4;
value_x   = plus_x + btn_s + 6;
mute_w    = ui_button_width("OFF");

// BACK
back_label = "BACK";
back_w = ui_button_width(back_label);
back_h = 16;
back_x = (room_width - back_w) / 2;
back_y = py + ph - back_h - 10;

// --- Actions ---
after_change = function() {
    audio_apply();
    audio_settings_save();
    sfx_play(snd_click);              // also lets the player hear the new SFX volume
};

change = function(_which, _delta) {   // _which: 0 = music, 1 = sfx
    if (_which == 0) global.audio_music = clamp(round((global.audio_music + _delta) * 10) / 10, 0, 1);
    if (_which == 1) global.audio_sfx   = clamp(round((global.audio_sfx   + _delta) * 10) / 10, 0, 1);
    after_change();
};

set_from_bar = function(_which, _mx) {
    var _v = round(clamp((_mx - bar_x) / bar_w, 0, 1) * 10) / 10;
    if (_which == 0) global.audio_music = _v;
    if (_which == 1) global.audio_sfx   = _v;
    after_change();
};

toggle_mute = function() {
    global.audio_muted = !global.audio_muted;
    after_change();
};

close = function() {
    sfx_play(snd_click);
    io_clear();
    instance_destroy();
};