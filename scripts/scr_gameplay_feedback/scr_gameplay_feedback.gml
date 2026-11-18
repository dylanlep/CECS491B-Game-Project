enum GameplayFeedback {
    WrongAnswer,
    CorrectAnswer,
    BlockPickup
}

function scr_gameplay_feedback(_event) {
    // SOUND ASSET HOOKS: Replace each noone with its imported GameMaker sound.
    var _sounds = [
        noone, // Wrong answer
        noone, // Correct answer
        noone  // Block pickup
    ];
    var _sound = _sounds[_event];
    if (_sound != noone) audio_play_sound(_sound, 0, false);

    if (_event == GameplayFeedback.WrongAnswer && view_enabled && view_camera[0] != -1) {
        if (shake_remaining_us <= 0) {
            shake_camera = view_camera[0];
            shake_origin_x = camera_get_view_x(shake_camera);
            shake_origin_y = camera_get_view_y(shake_camera);
        }
        shake_remaining_us = 120000; // 120 milliseconds
    }
}

function scr_update_gameplay_shake() {
    if (shake_remaining_us <= 0) return;

    shake_remaining_us -= delta_time;
    if (shake_remaining_us <= 0) {
        scr_reset_gameplay_shake();
        return;
    }

    // Sample offsets from the original position so the camera never drifts.
    camera_set_view_pos(shake_camera,
        shake_origin_x + irandom_range(-2, 2),
        shake_origin_y + irandom_range(-2, 2));
}

function scr_reset_gameplay_shake() {
    if (shake_camera == -1) return;

    camera_set_view_pos(shake_camera, shake_origin_x, shake_origin_y);
    shake_camera = -1;
    shake_remaining_us = 0;
}
