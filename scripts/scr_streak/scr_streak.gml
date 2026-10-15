/// scr_streak
/// Local-device daily lesson streak persistence.

function scr_streak_get_data() {
    var _today = date_date_of(date_current_datetime());

    ini_open("binary_brains_save.ini");
    var _count = ini_read_real("daily_streak", "count", 0);
    var _last_day = ini_read_real("daily_streak", "last_day", 0);
    ini_close();

    var _completed_today = (_last_day == _today);
    if (_last_day > 0 && _today > _last_day
    && date_day_span(_last_day, _today) > 1) {
        _count = 0;
    }

    return {
        count: max(0, _count),
        completed_today: _completed_today
    };
}

function scr_streak_record_lesson() {
    var _today = date_date_of(date_current_datetime());

    ini_open("binary_brains_save.ini");
    var _count = ini_read_real("daily_streak", "count", 0);
    var _last_day = ini_read_real("daily_streak", "last_day", 0);

    // Multiple lessons on the same calendar day count as one streak day.
    if (_last_day == _today || _last_day > _today) {
        ini_close();
        return _count;
    }

    if (_last_day <= 0) {
        _count = 1;
    } else if (date_day_span(_last_day, _today) == 1) {
        _count += 1;
    } else {
        _count = 1;
    }

    ini_write_real("daily_streak", "count", _count);
    ini_write_real("daily_streak", "last_day", _today);
    ini_close();

    return _count;
}
