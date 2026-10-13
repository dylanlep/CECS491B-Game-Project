
/// scr_layout_login_fields
/// Positions the visible fields based on current mode. Register shows
/// Username + Email + Password; Login shows Email + Password only.
/// Called once in Create, and again any time mode changes.
function scr_layout_login_fields(){


	var _y = 56;

	if (mode == MODE_REGISTER) {
	    username_box_y = _y;
	    _y += field_height + field_gap;
	    show_username = true;
	} else {
	    show_username = false;
	}

	email_box_y = _y;
	_y += field_height + field_gap;

	password_box_y = _y;
	_y += field_height + field_gap;

	submit_y1 = _y + 8;
	submit_y2 = submit_y1 + submit_height;

	toggle_y   = submit_y2 + 20;
	feedback_y = toggle_y + 14;
	
}