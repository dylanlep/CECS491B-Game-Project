/// scr_audio - SCRUM-52
/// Music volume, sound-effect volume and mute, saved in settings.ini.
///   audio_settings_init()  - load saved settings (safe to call any time)
///   audio_music_update()   - start the looping music once the browser allows audio
///   sfx_play(sound)        - play a sound effect at the player's SFX volume
///   audio_apply()          - apply changed volumes to the music that is playing
///   audio_settings_save()  - save the settings

#macro AUDIO_SETTINGS_FILE "settings.ini"

function audio_settings_init() {
    if (variable_global_exists("audio_ready")) return;
    global.audio_ready      = true;
    global.audio_music_inst = -1;

    ini_open(AUDIO_SETTINGS_FILE);
    global.audio_music = clamp(ini_read_real("audio", "music", 0.6), 0, 1);   // 0 = silent, 1 = full
    global.audio_sfx   = clamp(ini_read_real("audio", "sfx",   0.8), 0, 1);
    global.audio_muted = (ini_read_real("audio", "muted", 0) == 1);
    ini_close();
}

function audio_settings_save() {
    audio_settings_init();
    ini_open(AUDIO_SETTINGS_FILE);
    ini_write_real("audio", "music", global.audio_music);
    ini_write_real("audio", "sfx",   global.audio_sfx);
    ini_write_real("audio", "muted", global.audio_muted ? 1 : 0);
    ini_close();
}

/// Apply the current volume / mute to the music that is already playing.
function audio_apply() {
    audio_settings_init();
    if (global.audio_music_inst != -1 && audio_is_playing(global.audio_music_inst)) {
        audio_sound_gain(global.audio_music_inst, global.audio_muted ? 0 : global.audio_music, 0);
    }
}

/// Starts the looping music once audio is allowed (HTML5 waits for the first click/key).
function audio_music_update() {
    audio_settings_init();
    if (global.audio_music_inst != -1 && audio_is_playing(global.audio_music_inst)) return;
    if (!audio_system_is_available()) return;
    global.audio_music_inst = audio_play_sound(snd_music, 10, true, global.audio_muted ? 0 : global.audio_music);
}

/// Plays a sound effect at the player's SFX volume (nothing when muted).
function sfx_play(_snd) {
    audio_settings_init();
    if (global.audio_muted || global.audio_sfx <= 0) return;
    if (!audio_system_is_available()) return;
    audio_play_sound(_snd, 1, false, global.audio_sfx);
}